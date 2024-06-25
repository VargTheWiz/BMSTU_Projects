import MySQLdb

db = MySQLdb.connect(
    host="localhost",
    user="dbuser",
    passwd="JUSTANUMBER",
    db="first_db"
)

c=db.cursor()
c.execute("INSERT INTO books (name, description) VALUES (%s, %s);", ('Book', 'Description'))
db.commit()
c.close()
db.close()