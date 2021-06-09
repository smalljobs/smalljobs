namespace :smalljobs do

  desc 'Update todos postponed to null '
  task update_postponed_todos: :environment do
    @todos = Todo.postponed_obsolate
    @todos.update_all(postponed: nil)
  end

end
