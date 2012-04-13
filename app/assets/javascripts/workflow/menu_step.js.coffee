#= require workflow/step

onWorkflow ->
  class window.Menu extends Step
    constructor: (attrs) ->
      super(attrs)

      @name = ko.observable attrs['name'] || 'Menu'
      @options = ko.observableArray([])

      @new_option_command = ko.observable null
      @current_editing_message = ko.observable null

      @messages =
        end_call: Message.from_hash(attrs.end_call_message).with_title('End call').with_parent(@)
        invalid:  Message.from_hash(attrs.invalid_message).with_title('Invalid').with_parent(@)
        explanation: Message.from_hash(attrs.explanation_message).with_title('Explanation').with_parent(@)
        options:  Message.from_hash(attrs.options_message).with_title('Options').with_parent(@)

      @is_editing_message = ko.computed () =>
        @current_editing_message() != null

      @available_numbers = ko.computed () =>
        used_numbers = (opt.number() for opt in @options())
        (number for number in [1,2,3,4,5,6,7,8,9,0] when number not in used_numbers)

    display_template_id: () =>
      'menu_step_template'

    button_class: () =>
      'ldial'

    next_ids: () =>
      (option.next_id for option in @options())

    commands: () =>
      (command.name() for command in workflow.commands())

    @add_to_steps: () ->
      workflow.add_step(new Menu)

    @from_hash: (hash) ->
      menu = new Menu(hash)
      menu.options(new MenuOption(opt.number, opt.next, menu) for opt in (hash.options || []))
      return menu

    to_hash: () =>
      id: @id
      name: @name()
      type: 'menu'
      root: @root
      options: (option.to_hash() for option in @options())
      end_call_message: @messages['end_call'].to_hash()
      invalid_message: @messages['invalid'].to_hash()
      explanation_message: @messages['explanation'].to_hash()
      options_message: @messages['options'].to_hash()

    add_option: () =>
      new_step = workflow.create_step(@new_option_command(), @)
      @options.push(new MenuOption(@available_numbers()[0], new_step.id, @))

    remove_option: (option) =>
      if confirm("Are you sure you want to remove option #{option.next().name()} and all steps after it?")
        @options.remove option
        option.remove_next()

    child_removed: (child) =>
      for option in @options()
        if option.next_id == child.id
          @options.remove option
          break

    remove: (notify=true) =>
      for option in @options()
        option.remove_next()
      super(notify)

    message: (msg) =>
      @messages[msg]

    show_message: (msg) =>
      msg = @messages[msg]
      @current_editing_message(msg)

    show_end_call_message: () =>
      @show_message('end_call')

    show_invalid_message: () =>
      @show_message('invalid')

    show_options_message: () =>
      @show_message('options')

    show_explanation_message: () =>
      @show_message('explanation')