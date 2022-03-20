'use strict'
var AWS = require('aws-sdk');
var S3 = new AWS.S3();
var excel = require('excel4node');
var lambda = new AWS.Lambda()
var nodemailer = require('nodemailer');
var workbook = new excel.Workbook();
var worksheet = workbook.addWorksheet('Weekly Report');
var date = new Date();
var start = new Date(date.getFullYear(), date.getMonth(), date.getDate()-7).toLocaleDateString("en-US")
var end = new Date(date.getFullYear(), date.getMonth(), date.getDate()+1).toLocaleDateString("en-US")
var today = new Date(date.getFullYear(), date.getMonth(), date.getDate()).toLocaleDateString("en-US")

module.exports.handler = async (event, context, callback) => {

  var docClient = new AWS.DynamoDB.DocumentClient();
  var params = {
    // Specify which items in the results are returned.
    FilterExpression: "#created between :start and :end",
    ExpressionAttributeNames: {
        "#created": "CreatedAt",
    },
    ExpressionAttributeValues: {
        ":start": start,
        ":end": end
    },
    // Set the projection expression, which are the attributes that you want.
    ProjectionExpression: "OrderedItems, Currency",
    TableName: "orders_db",
  };

  var data = await docClient.scan(params).promise()
  
  var orders = data.Items;

  date = date.toLocaleString('en-US', { dateStyle: 'long' });
  var dateParts = /(.*?)\s(\d*)\,\s(\d*)/g.exec(date);
  var year = dateParts[3];
  var month = dateParts[1].substring(0, 3);
  var day = dateParts[2];
  day = (day.toString()).length > 1 ? day : '0' + day;
  date = `${year} ${month} ${day}`;

  var intro = `Sales report for ${start} - ${today}`

  // Calculate totals
  // orders.sort((a, b) => (a.date > b.date) ? -1 : 1);
  const productSales = new Map();
  const productItemSold = new Map();
  var total = 0;

  orders.forEach((order, i) => {
    let items = order.OrderedItems
    items.forEach((item, j) => {
      let subtotal = item.Quantity * item.Price
      total += subtotal

      if (productSales.has(item.ItemName)) {
        let update = productSales.get(item.ItemName) + subtotal
        productSales.set(item.ItemName, update);
      } else {
        productSales.set(item.ItemName, subtotal);
      }

      if (productItemSold.has(item.ItemName)) {
        let update = productItemSold.get(item.ItemName) + item.Quantity
        productItemSold.set(item.ItemName, update);
      } else {
        productItemSold.set(item.ItemName, item.Quantity);
      }
    });
  });

  // Headers + Columns (Row, Column)
  worksheet.cell(1, 1).string(intro).style({font: {bold: true}});
  worksheet.cell(1, 3).string('Grand Total Sales').style({font: {bold: true}});
  worksheet.cell(1, 4).string(total.toString()).style({font: {bold: true}});
  worksheet.cell(4, 2).string('ProductId');
  worksheet.cell(4, 3).string('Price');
  worksheet.cell(4, 4).string('Total Sold');
  worksheet.cell(4, 5).string('Total Sales');
  worksheet.cell(4, 6).string('Percentage of Grand Total Sales');
      
  // Get all products
  var getProductsParams = {
    FunctionName: process.env.GET_PRODUCTS_LAMBDA, /* required */
    InvocationType: "RequestResponse",
    Payload: "",
  };

  let getProductsResp = await lambda.invoke(getProductsParams).promise()
  
  if ((JSON.parse(getProductsResp.Payload)).statusCode != 200) {
    throw "get products error";
  }

  let payload = JSON.parse(getProductsResp.Payload)
  let products = JSON.parse(payload.body).Items
  
  // Create rows for each product item
  products.forEach((product, i) => {
    let productSale
    let percent
    let productSold = productItemSold.get(product.ProductName)
    if (productSold != null) {
      productSale = productSales.get(product.ProductName)
      percent = Math.round((productSale / total * 100) * 100) / 100
    } else {
      productSold = 0
      productSale = 0
      percent = 0
    }
    worksheet.cell(5+i, 1).string(product.ProductName);
    worksheet.cell(5+i, 2).string(product.ProductId.toString());
    worksheet.cell(5+i, 3).string(product.Price.toString());
    worksheet.cell(5+i, 4).string(productSold.toString());
    worksheet.cell(5+i, 5).string(productSale.toString());
    worksheet.cell(5+i, 6).string(percent.toString());
  });
  
  var buffer = await workbook.writeToBuffer()

  var s3Params = {
    Bucket: process.env.S3Bucket,
    Key: `${date}.xlsx`,
    Body: buffer,
    ACL: 'public-read'
  }

  var body = await S3.upload(s3Params).promise()

  // Send Email Attachment
  var mailOptions = {
      from: process.env.MailSender,
      subject: `Weekly Sales Report for ${start} - ${today}`,
      html: `<p>Find in the attached the weekly sales report for <b>${start} - ${today}</b></p>`,
      to: process.env.MailRecipient,
      // bcc: Any BCC address you want here in an array,
      attachments: [
          {
              filename: `${date}.xlsx`,
              content: buffer
          }
      ]
  };

  // create Nodemailer SES transporter
  var transporter = nodemailer.createTransport({
      SES: new AWS.SES()
  });

  // send email
  await transporter.sendMail(mailOptions);

  body = JSON.stringify(body);
  
  return body
  
};
