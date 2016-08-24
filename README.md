#dataMagik

DataMagik creates a relationship between models (database tables) and classes. A class can easily
gain access to dataMagik's methods through inheritance and be mapped to a table. Conveniently, utilizing this
model-to-table relationship, dataMagik can also define relationships between classes (and therefore database tables).
These relationships are commonly referred to as 'associations'.

The 'Magik' behind dataMagik relies on the user following correct naming protocols. The table name must
be all lowercase and plural (ie 'players') and the class name must be capitalized and singular (ie 'Player'). However,
if the user wishes, relationships can be defined explicitly and the class_name, primary/foreign key columns can be directly
cited.


###Accessing Database models

DataMagik gives a plethora of methods with which to access the database.

**Methods**
- #table_name
- #model_name
- #save
- #update
- ::find
- ::where
- ::all
- ::new
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
table_name = Player.table_name
```

**Get all the instances in a model**

```javascript
all_players = Player.all
```

**Find one instance by id**

```javascript
player = Player.find(id)
```

**Add an instance to your DB**

```javascript
Player.new({ name: "Clemens", team_id: 1 }).save
```

**Update an instance in your DB**

```javascript
player = Player.find(1)
player.update({ name: "Damon", team_id: 1 })
```


###dataMagik Associations

Three association methods are included in dataMagik.

**belongs_to**
Parameters accepted:
- association method name
- :foreign_key
- :class_name
- :primary_key

**has_many**
Parameters accepted:
- association method name
- :foreign_key
- :class_name
- :primary_key

**has_one_through**
This is used to create a relationship between two models that are related through a third table
Parameters accepted:
- association method name
- through method
  - this calls the first association that links the beginning model to the middle table
- source method
  - this calls the second association that links the middle table to the desired second model

###How To Use:

- Clone this repo into your project
- You need to require_relative './dataMagik/data_magic'
- You MUST call 'DBConnection.open(YOUR_OWN_PATH_TO_DB_FILE)' to load your SQLite3 DB
- Use the supplied methods to manipulate and query your data!

These are sample models you might write:

```javascript
require 'data_magic'

class Player < SQLObject
  belongs_to :team, foreign_key: :team_id
  has_one_through (
    :team_owner,
    through: :team,
    source: :owner)
end

class Team < SQLObject
  belongs_to :owner, foreign_key: :owner_id
  has_many (
    :players,
    class_name: 'Player',
    foreign_key: :team_id,
    primary_key: :id)
end
```
A few notes on the above code:
- the has_many association in the Team class could have been written as:
``` javascript
has_many(:players)
```
- the method has defaults where:
 - the class_name is the method name (but singular and capitalized)
 - the foreign_key is the class name (but lowercase)
 - the primary_key is simply :id


And here are a couple examples of how you might use those associations

```javascript
player_owner = Player.where(name: "Jeter").team_owner
team_roster = Team.find(1).players
```
