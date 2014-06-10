
class Space.Module

  injector: null
  RequiredModules: null
  isInitialized: false

  constructor: -> @RequiredModules ?= []

  initialize: (injector, modules) ->

    if not injector? then throw new Error 'Space.Module::initialize needs an instance of Dependance.Injector as first argument.'

    for module in @RequiredModules

      unless modules[module]?
        moduleClass = Space.Module.require(module, this.constructor.name)
        modules[module] = new moduleClass()

      module = modules[module]

      if !module.isInitialized then module.initialize(injector, modules)

    @injector = injector
    @injector.injectInto this

    @isInitialized = true
    @configure()

  configure: ->

  @published = {}

  @publish: (module, identifier) ->

    if Space.Module.published[identifier]?
      throw new Error "Two modules tried to be published as <#{identifier}>"
    else
      Space.Module.published[identifier] = module

  @require: (requiredModule, requestingModule) ->

    module = Space.Module.published[requiredModule]

    if not module?
      throw new Error "Could not find module <#{requiredModule}> required by <#{requestingModule}>"
    else
      return module
