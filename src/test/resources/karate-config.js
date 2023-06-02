function fn() {
    karate.configure('connectTimeout', 15000);
    karate.configure('readTimeout', 15000);
    karate.configure('ssl', true);

    var baseUrl = karate.properties['baseUrl'] || 'https://restful-booker.herokuapp.com'

    return {
        api: {
           baseUrl: baseUrl
        }
    };
}