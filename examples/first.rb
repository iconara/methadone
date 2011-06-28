$: << File.expand_path('../../lib', __FILE__)

require 'methadone'


class Worker
  def initialize(app_name, manager, id, name)
    @app_name, @manager, @id, @name = app_name, manager, id, name
  end
  
  def work
    puts "#{@id} (#{@name}) working in #{@app_name} for #{@manager} (#{object_id})"
  end
end

class Manager
end

class Runner
  def initialize(worker)
    @worker = worker
  end
  
  def run
    @worker.work
  end
end

include Methadone::Dsl

f = factory do
  define :app_name, 'test'
  register :worker, ::Worker, [app_name, manager, 1, 'Phil']
  register :manager, ::Manager
  register :runner, ::Runner, [worker], :type => :prototype
end

r1 = f[:runner]
r2 = f[:runner]

puts r1.object_id
puts r2.object_id

r1.run
r2.run