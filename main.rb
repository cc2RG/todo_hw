require 'pry-byebug'
require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pg'

get '/tasks' do
  #get all tasks from db
  sql = "SELECT * FROM tasks"
  @tasks = run_sql(sql)
  
  erb :index
end  

get '/tasks/new' do
  #render form to add tasks

  erb :new
end 

post '/tasks' do
  #persist new task to db
  name = params[:name]
  details = params[:details]
  sql = "INSERT INTO tasks(name, details) VALUES('#{name}','#{details}')"
  run_sql(sql)
  redirect to('/tasks') 
end 

get '/tasks/:id' do
    
   
   sql = "SELECT * FROM tasks WHERE id = #{params[:id]}" 
   @individual_tasks = run_sql(sql)
   erb :show

end  

get '/tasks/:id/edit' do

   sql = "SELECT * FROM tasks WHERE id = #{params[:id]}" 
   @individual_tasks = run_sql(sql).first
  
  erb :edit
  # grab task from db and render form
end  

post '/tasks/:id' do
 @name = params[:name]
  @details = params[:details]
  @id = params[:id]
  sql = "UPDATE tasks SET name = '#{@name}', details = '#{@details}' WHERE id = '#{@id}'" 
  
  erb :edit
 # grab params and update in db
end

delete '/tasks/:id/delete' do
 # Destroy in db
end  

def run_sql(sql)
  conn = PG.connect(dbname: 'todo', host: 'localhost') 
  result = conn.exec(sql)
  conn.close
  result
end  





