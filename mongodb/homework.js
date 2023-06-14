// Zadanie 1. Operacje wyszukiwania danych.

// a)
db.getCollection('business').find(
    {
        'categories': { $elemMatch: { $eq: 'Restaurants' } },
        'hours.Monday': { $exists: true },
        'stars': { $gte: 4 }
    },
    {
        'name': true,
        'full_address': true,
        'categories': true,
        'hours': true,
        'stars': true
    },
    {
        sort: [ 'name' ]
    }
);

// b)
db.getCollection('business').aggregate(
    [
        { $match: { 'categories': {
            $in: [ 'Hotels & Travel', 'Hotels' ]
        } } },
        { $group: {
            '_id': '$city',
            'hotel_count': { $count: {} }
        } },
        { $sort: { 'hotel_count': -1 } }
    ]
);

// c)
db.getCollection('tip').aggregate([
    { $match: { 'date': { $regex: /^2012/ } } },
    { $group: {
        '_id': '$business_id',
        'tip_count': { $count: {} }
    } },
    {
        $lookup: {
            from: 'business',
            localField: '_id',
            foreignField: 'business_id',
            as: 'business'
        }
    },
    { $sort: { 'tip_count': -1 } },
    {
        $project: {
            'business_name': { $first: '$business.name' },
            'tip_count': 1
        }
    }
]);

// d)
db.getCollection('review').aggregate([
    { 
        $project: {
            'votes': { $objectToArray: '$votes' }
        }
    },
    { $unwind: '$votes' },
    { $match: { 'votes.v': { $gt: 0 } } },
    {
        $group: {
            '_id': '$votes.k',
            'count': { $count: {} },
            'total': { $sum: '$votes.v' }
        }
    }
]);

// e)
db.getCollection('user').aggregate([
    {
        $match: {
            'votes.funny': 0,
            'votes.useful': 0,
            'type': 'user'
        }
    },
    { $sort: { 'name': 1 } }
]);

// f)
// 1
db.getCollection('review').aggregate([
    {
        $group: {
            '_id': '$business_id',
            'stars_mean': { $avg: '$stars' }
        }
    },
    { $match: { 'stars_mean': { $gt: 3 } } },
    { $sort: { '_id': 1 } },
]);

// 2
db.getCollection('review').aggregate([
    {
        $group: {
            '_id': '$business_id',
            'stars_mean': { $avg: '$stars' }
        }
    },
    { $match: { 'stars_mean': { $gt: 3 } } },
    {
        $lookup: {
            from: 'business',
            localField: '_id',
            foreignField: 'business_id',
            pipeline: [{ $group: { '_id': '$name' } }],
            as: 'business'
        }
    },
    {
        $project: {
            '_id': 0,
            'business_name': { $first: '$business._id' },
            'stars_mean': 1
        }
    },
    { $sort: { 'business_name': 1 } }
]);

////////////////////////////////////////////////////////////////////


// Zadanie 2. Modelowanie danych.

// a)
// 1
// Lecturers
const exampleLecturer1 = {
    "personalDetails": {
        "firstName": "John",
        "lastName": "Doe",
        "realLifeId": "532214321",
        "nationality": "Scottish"
        // pozostałe dane, nr telefonu, email uczelniany itd.
        // ...
    },
    "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
    "degree": "Doctor of Philosophy",
    "roles": [
        "Head of the department"
        // ...
    ],
    "taughtCourses": [
        ObjectId("_id_course_0"),
        ObjectId("_id_course_1")
        // ...
    ]
};

// Courses
const exampleCourse1 = {
    "name": "Data Structures and Algorithms",
    "academicYear": [ 2021, 2022 ],
    "description": "Algorithms, yeah.",
    "participants": [
        ObjectId("_id_student_0"),
        ObjectId("_id_student_1"),
        ObjectId("_id_student_2"),
        ObjectId("_id_student_3"),
        ObjectId("_id_student_4")
        // ...
    ],
    "reviews": [
        {
            "value": 10,
            "date": new Date(),
            "comment": "Yeah, cool.",
            "issuedBy": ObjectId("_id_anne_kowalski"),
        }
    ]
};

// Students
const exampleStudent1 = {
    "personalDetails": {
        "firstName": "Anne",
        "lastName": "Kowalski",
        "realLifeId": "00211388482",
        "nationality": "Polish"
        // pozostałe dane, nr telefonu, email uczelniany itd.
        // ...
    },
    "major": "Computer Science", 
    "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
    "participatedCourses": [
        ObjectId("_id_course_0"),
        ObjectId("_id_course_1"),
        ObjectId("_id_course_2")
        // ...
    ],
    "grades": [
        {
            "value": 4.5,
            "date": new Date(),
            "issuedBy": ObjectId("_id_john_doe"),
            "courseId": ObjectId("_id_dsa_course")
        }
        // ...
    ]
};

// 3
const exampleLecturer3 = {
    "personalDetails": {
        "firstName": "John",
        "lastName": "Doe",
        "realLifeId": "532214321",
        "nationality": "Scottish"
        // pozostałe dane, nr telefonu, email uczelniany itd.
        // ...
    },
    "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
    "degree": "Doctor of Philosophy",
    "roles": [
        "Head of the department"
        // ...
    ],
    "taughtCourses": [
        {
            "name": "Data Structures and Algorithms",
            "academicYear": [ 2021, 2022 ],
            "description": "Algorithms, yeah.",
            "participants": [
                {
                    "personalDetails": {
                        "firstName": "Anne",
                        "lastName": "Kowalski",
                        "realLifeId": "00211388482",
                        "nationality": "Polish"
                        // pozostałe dane, nr telefonu, email uczelniany itd.
                        // ...
                    },
                    "major": "Computer Science", 
                    "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
                }
                // ...
            ],
            "reviews": [
                {
                    "value": 10,
                    "date": new Date(),
                    "comment": "Yeah, cool.",
                    "issuedBy": {
                        "personalDetails": {
                            "firstName": "Anne",
                            "lastName": "Kowalski",
                            "realLifeId": "00211388482",
                            "nationality": "Polish"
                            // pozostałe dane, nr telefonu, email uczelniany itd.
                            // ...
                        },
                        "major": "Computer Science", 
                        "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
                    },
                }
            ]
        }
        // ...
    ]
};

// Courses
const exampleCourse3 = {
    "name": "Data Structures and Algorithms",
    "academicYear": [ 2021, 2022 ],
    "description": "Algorithms, yeah.",
    "participants": [
        {
            "personalDetails": {
                "firstName": "Anne",
                "lastName": "Kowalski",
                "realLifeId": "00211388482",
                "nationality": "Polish"
                // pozostałe dane, nr telefonu, email uczelniany itd.
                // ...
            },
            "major": "Computer Science", 
            "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
            "participatedCourses": [

                // ...
            ],
            "grades": [
                {
                    "value": 4.5,
                    "date": new Date(),
                    "issuedBy": ObjectId("_id_john_doe"),
                    "courseId": ObjectId("_id_dsa_course")
                }
                // ...
            ]
        }
        // ...
    ],
    "reviews": [
        {
            "value": 10,
            "date": new Date(),
            "comment": "Yeah, cool.",
            "issuedBy": ObjectId("_id_anne_kowalski"),
        }
    ]
};

// Students
const exampleStudent3 = {
    "personalDetails": {
        "firstName": "Anne",
        "lastName": "Kowalski",
        "realLifeId": "00211388482",
        "nationality": "Polish"
        // pozostałe dane, nr telefonu, email uczelniany itd.
        // ...
    },
    "major": "Computer Science", 
    "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
    "participatedCourses": [
        {
            "name": "Data Structures and Algorithms",
            "academicYear": [ 2021, 2022 ],
            "description": "Algorithms, yeah.",
            "participants": [
                {
                    "personalDetails": {
                        "firstName": "Anne",
                        "lastName": "Kowalski",
                        "realLifeId": "00211388482",
                        "nationality": "Polish"
                        // pozostałe dane, nr telefonu, email uczelniany itd.
                        // ...
                    },
                    "major": "Computer Science", 
                    "faculty": "Faculty of Computer Science, Electronics and Telecomunications",
                }
                // ...
            ],
        }
        // ...
    ],
    "grades": [
        {
            "value": 4.5,
            "date": new Date(),
            "issuedBy": ObjectId("_id_john_doe"),
            "courseId": ObjectId("_id_dsa_course")
        }
        // ...
    ]
};
