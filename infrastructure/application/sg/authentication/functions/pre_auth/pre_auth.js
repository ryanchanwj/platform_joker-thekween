exports.handler = async (event, context) => {
    let newScopes = event.request.groupConfiguration.groupsToOverride.map(item => `${item}-${event.callerContext.clientId}`)
event.response = {
    "claimsOverrideDetails": {
        "claimsToAddOrOverride": {
            "scope": newScopes.join(" "),
        }
    }
  };
  return event
}