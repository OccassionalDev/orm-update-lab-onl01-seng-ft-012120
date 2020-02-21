require_relative "../config/environment.rb"

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade 
    @id = id 
  end 
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER 
      )
    SQL
    
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table 
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end
  
  def save 
    if self.id 
      self.update
    end 
    
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end 
  
  def self.new_from_db(row) 
    id = row[0]
    name = row[1]
    grade = row[2]
    
    new_student = Student.new(id, name, grade)
    
    new_student
  end 
  
  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    
    new_student
  end 
  
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    
    DB[:conn].execute(sql, name).collect do |row|
      
    end.first
  end 
  
  def update
    sql = <<-SQL 
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end 


end
