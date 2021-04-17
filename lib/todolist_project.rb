# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title, :todos

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError.new "Can only add Todo objects" unless todo.class == Todo 
    todos << todo
    self
  end

  def <<(todo)
    self.add(todo)
  end

  def size
    todos.size 
  end

  def first
    todos.first
  end

  def last 
    todos.last 
  end

  def to_a
    result = []
    todos.each {|todo| result << todo}
    result
  end

  def done?
    flag = false
    todos.each {|todo| flag = todo.done?}
    flag
  end

  def item_at(idx)
    raise IndexError.new if idx > todos.size
    todos[idx]
  end

  def mark_done_at(idx)
    raise IndexError.new if idx > todos.size
    todos[idx].done!
  end

  def mark_undone_at(idx)
    raise IndexError.new if idx > todos.size
    todos[idx].undone!
  end

  def done!
    todos.each {|todo| todo.done!}
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(idx)
    raise IndexError.new if idx > todos.size
    todos.delete_at(idx)
  end

  def to_s
    result = "---- #{self.title} ----\n"
    todos.each {|todo| result << todo.to_s + "\n"}
    result
  end

  def each
    idx = 0

    while idx < todos.length 
      yield(todos[idx])
      idx += 1
    end
    self
  end

  def select
    result = TodoList.new("Today's Todos")

    todos.each do |todo| 
      result << todo if yield(todo)
    end

    result 
  end

  #takes a string as argument, and returns the first Todo object that matches the argument. 
  #Return nil if no todo is found.
  def find_by_title(string)
    select {|todo| todo.title == string}.first
  end

  #returns new TodoList object containing only the done items
  def all_done
    result = TodoList.new("List of Done Items")
    each {|todo| result << todo if todo.done?}
    result
  end

  #returns new TodoList object containing only the not done items
  def all_not_done
    result = TodoList.new("List of Undone Items")
    each {|todo| result << todo if !todo.done?}
    result
  end

  #takes a string as argument, and marks the first Todo object that matches the argument as done.
  def mark_done(string)
    select {|todo| string == todo.title && !todo.done?}.done!
  end

  #mark every todo as done
  def mark_all_done
    each {|todo| todo.done!}
  end

  #mark every todo as not done
  def mark_all_undone
    each {|todo| todo.undone!}
  end
end


