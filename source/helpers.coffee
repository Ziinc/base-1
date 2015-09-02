
global = this

# Define global namespace for the space framework
@Space = {}

# Resolves a (possibly nested) path to an global object
# Returns the object or null (if not found)
Space.resolvePath = (path) ->
  if path == '' then return global
  path = path.split '.'
  result = global # Start with global namespace
  for key in path # Move down the object chain
    result = result?[key] ? null
    # Take published space modules into account
    # to solve the Meteor package scoping problem
    if !result? then result = Space.Module.published[key]
  return result
