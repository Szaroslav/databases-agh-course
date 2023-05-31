// Mongosh

// Zadanie 2
db.createCollection('BazyTestCollection');
db.getCollectionNames();

// Zadanie 5
db.createCollection('student');
// Struktura
{
	"name": {
		"firstName":
		"lastName":
	},
	"address": {
		"street": "",
		"city": "",
		"zipCode": ""
	},
	attendedCourses: [Course],
	grades: [Grade] // grade będzie posiadało id przedmiotu
}
// Dokumenty
db.getCollection('student').insertOne({"name": {"firstName": "Jakub", "lastName": "Szaredko"}, "address": {"street": "Krakowska 33", "city": "Kraków", "zipCode": "00-000"}, "attendedCourses": ["Databases"], "grades": [2]});
db.getCollection('student').insertOne({"name": {"firstName": "Anna", "lastName": "Kowalska"}, "address": {"street": "Wrocławska 1", "city": "Kraków", "zipCode": "00-000"}, "attendedCourses": ["Databases"], "grades": [5]});

// Modyfikacja
db.getCollection('student').updateOne({"name": {"firstName": "Jakub", "lastName": "Szaredko"}}, {$set: {
 "address": {"street": "Wiejska 333", "city": "Białystok", "zipCode": "01-000"}});

// Usuwanie
db.getCollection('student').deleteOne({ "_id": ObjectId("64773ae580880f75fa426a32") });

// Wyszukiwanie
db.getCollection('student').findOne({"name": {"firstName": "Jakub", "lastName": "Szaredko"}});
