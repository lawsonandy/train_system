class Train
  attr_reader :id, :name

  def initialize(attrs)
    @name = attrs.fetch(:name)
    @id = attrs.fetch(:id)
  end

  def self.all
    returned_trains = DB.exec("SELECT * FROM trains")
    trains = []
    returned_trains.each() do |train|
      name = train.fetch("name")
      id = train.fetch("id").to_i
      trains.push(Train.new({:name => name, :id => id}))
    end
    trains
  end

  def save
    result = DB.exec("INSERT INTO trains (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(train_to_compare)
    self.name() == train_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM trains *;")
  end

  def self.find(id)
    train = DB.exec("SELECT * FROM trains WHERE id = #{id};").first
    name = train.fetch("name")
    id = train.fetch("id").to_i
    Train.new({:name => name, :id => id})
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE trains SET name = '#{@name}' WHERE id = #{@id};")
    end
  end

  def delete
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
  end

  def cities
    City.find_by_train(self.id)
  end

  def self.find_by_city(city_id)
    trains = []
    returned_trains = DB.exec("SELECT * FROM stops WHERE city_id = #{city_id};")
    returned_trains.each() do |train|
      train_id = train.fetch("train_id").to_i()
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id}")
      name = train.fetch("name")
      id = train.fetch("id").to_i
      trains << (Train.new({:name => name, :id => id}))
    end
    trains
  end

end