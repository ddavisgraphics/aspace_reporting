# Connects to DB using mysql2 gem
class Database
  # define getters and setters 
  attr_accessor :db_host, :db_user, :db_pass, :db_port, :db_name
  
  # set some defaults on new 
  def initialize 
    @db_host  = "127.0.0.1"
    @db_user  = "root"
    @db_pass  = "123456"
    @db_name = "archivesspace"
    @db_port = "3306"
    self.connect
  end

  # connect to db 
  def connect
    @connection = Mysql2::Client.new(
      :host => @db_host, 
      :username => @db_user, 
      :password => @db_pass, 
      :port => @db_port, 
      :database => @db_name
    )
    @connection.query_options.merge!(:symbolize_keys => true)
  end

  # db queries 
  def query sql_statement
    @connection.query(sql_statement)
  end

  def escape str
    @connection.escape(str)
  end
end