class ChineseSetting

  constructor: ->
    console.log '执行 constructor'
    CSON = require 'cson'
    #菜单
    @M = CSON.load __dirname + '/../def/menu_'+process.platform+'.cson'
    #右键菜单
    @C = CSON.load __dirname + '/../def/context.cson'


  activate: (state) ->
    console.log '执行 activate'
    setTimeout(@delay,0)

  delay: () =>
    console.log '执行 delay'
    # Menu
    @updateMenu(atom.menu.template, @M.Menu)
    atom.menu.update()

    # ContextMenu
    @updateContextMenu()

    #console.log @S
    # Settings (on init and open)
    @updateSettings()
    #快捷键打开 setting 时
    atom.commands.add 'atom-workspace', 'settings-view:open', =>
      @updateSettings(true)

    atom.workspace.onDidOpen  =>
      @updateSettings(true)

  updateMenu : (menuList, def) ->
    console.log '执行 updateMenu'
    return if not def
    for menu in menuList
      continue if not menu.label
      key = menu.label
      if key.indexOf '…' isnt -1
        key = key.replace('…','...')
      set = def[key]
      continue if not set
      menu.label = set.value if set?
      if menu.submenu?
        @updateMenu(menu.submenu, set.submenu)

  updateContextMenu: () ->
    console.log '执行 updateContextMenu'
    for itemSet in atom.contextMenu.itemSets
      set = @C.Context[itemSet.selector]
      continue if not set
      for item in itemSet.items
        continue if item.type is "separator"
        label = set[item.command]
        item.label = label if label?

  updateSettings: (onSettingsOpen = false) ->
    console.log '执行updateSettings：'+onSettingsOpen
    setTimeout(@delaySettings, 0, onSettingsOpen)

  delaySettings: (onSettingsOpen) ->
    console.log '执行delaySettings'
    settings = require './../tools/settings'
    settings.init()

module.exports = new ChineseSetting()
