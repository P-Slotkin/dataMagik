#dataMagik

DataMagik creates a relationship between models (database tables) and classes. A class can easily
gain access to dataMagik's methods through inheritance and be mapped to a table. Conveniently, utilizing this
model-to-table relationship, dataMagik can also define relationships between classes (and therefor database tables).
These relationships are commonly referred to as 'associations'.

The 'Magik' behind dataMagik relies on the user following correct naming protocols. The table name must
be all lowercase and plural (ie 'dogs') and the class name must be capitalized and singular (ie 'Dog'). However,
if the user wishes, relationships can be defined explicitly and the class_name, primary/foreign key columns can be directly
cited.


###Accessing Database models

DataMagik gives a plethora of methods with which to access the database.

**Methods**
- #table_name
- #model_name
- #where
- ::find
- ::all
- ::new
- ::save
- ::update
- ::first
- ::last
- ::columns
- ::attributes
- ::belongs_to
- ::has_many
- ::has_one_through

Here are examples of a few:

**Get the table name**

```javascript
table_name = Dog.table_name
```

**Get all the instances in a model**

```javascript
all_instances = Dog.all
```

**Find one instance by id**

```javascript
instance = Dog.find(id)
```

**Add an instance to your DB**

```javascript
Dog.new({ name: "Rex", owner_id: 2 }).save
```

**Update an instance in your DB**

```javascript
dog = Dog.find(1)
Dog.update({ name: "T-Rex", owner_id: 2 })
```


###dataMagik Associations

Three association methods are included in dataMagik.

**belongs_to**
Parameters accepted:
- association method name
- :foreign_key
- :class_name
- :primary_key

An example of `belongs_to`
```javascript
belongs_to(:parent, class_name: "Dogparent", foreign_key: :id, primary_key: :dog_id)
```

**has_many**
Parameters accepted:
- association method name
- :foreign_key
- :class_name
- :primary_key

An example of `has_many`
```javascript
has_many(:parent, class_name: "Dogchild", foreign_key: :child_id, primary_key: :id)
```

**has_one_through**
This is used to create a relationship between two models that are related through a third table
Parameters accepted:
- association method name
- through method
  - this calls the first association that links the beginning model to the middle table
- source method
  - this calls the second association that links the middle table to the desired second model

An example of 'has_one_through' (from the model of a grandparents)
```javascript
has_one_through(:grandchildren, through: :children, source :children)
```
