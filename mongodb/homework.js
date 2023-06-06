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
db.getCollection('tip').aggregate([
    {
        $lookup: {
            from: 'business',
            localField: 'business_id',
            foreignField: 'business_id',
            as: 'business'
        }
    },
    {
        $project: {
            'business_name': { $first: '$business.name' },
            'date': { $dateFromString: { dateString: '$date' } }
        }
    },
    {
        $project: {
            'business_name': '$business_name',
            'year': { $year: '$date' }
        }
    },
    { $match: { 'year': { $eq: 2012 } } },
    { $group: {
        '_id': '$business_name',
        'tip_count': { $count: {} }
    } },
    { $sort: { 'tip_count': -1 } }
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