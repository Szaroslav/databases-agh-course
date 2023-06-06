// Zadanie 1
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
        { $match: { 'categories': { $in: [ 'Hotels & Travel', 'Hotels' ] } } },
        { $group: { '_id': '$city', 'hotel_count': { $count: {} } } },
        { $sort: { 'hotel_count': -1 } }
    ]
);

// c)
