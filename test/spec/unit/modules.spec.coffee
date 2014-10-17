(->
    "use strict"

    Activity = undefined
    ActivityStreamModule = undefined
    Logger = undefined
    User = undefined
    Mapper = undefined

    before (done) ->
        require [
            "modules/activity",
            "modules/activityStream",
            "modules/logger",
            "modules/user"
            "modules/mapper"
        ],(_Activity, _ActivityStreamModule, _Logger, _User, _Mapper) ->
            Activity = clone(_Activity)
            ActivityStreamModule = clone(_ActivityStreamModule)
            Logger = clone(_Logger)
            User = clone(_User)
            Mapper = clone(_Mapper)
            done()


    describe "App.Modules Unit Tests", ->
        describe "Activity Module", ->
            it "Can create a new instance of an Activity module", (done) ->
                @activity = new Activity()
                expect(@activity).to.be.ok
                done()

        describe "ActivityStreamModule Module", ->
            it "Can create a new instance of an ActivityStreamModule module", (done) ->
                @activityStream = new ActivityStreamModule()
                expect(@activityStream).to.be.ok
                expect(@activityStream).to.be.an("object")
                done()

            it "Match activities activities of the user", (done) ->
                config =
                    user:
                        type: 'mmdb_user',
                        id: 1

                @activityStream = new ActivityStreamModule()
                @activityStream.ready(config)
                expect(@activityStream).to.be.ok
                message =
                    "actor":
                        "id":"6635",
                        "data":
                            "api":"http://localhost/user/1",
                            "aid":"1","type":"db_user"
                    "verb":
                        "type":"FAVORITED"
                    "object":
                        "data":
                            "api":"//otherpage/api/v1/article/1/",
                            "aid":"1",
                            "type":"cms_article"

                expect(@activityStream.matchActivity(message)).to.be.ok
                done()

            it "Ignore activities of other users", (done) ->
                config =
                    user:
                        type: 'mmdb_user',
                        id: 1

                @activityStream = new ActivityStreamModule()
                @activityStream.ready(config)
                expect(@activityStream).to.be.ok
                message =
                    "actor":
                        "id":"6635",
                        "data":
                            "api":"http://localhost/user/2",
                            "aid":"2",
                            "type":"db_user"
                    "verb":
                        "type":"FAVORITED"
                    "object":
                        "data":
                            "api":"//otherpage/api/v1/article/1/",
                            "aid":"1",
                            "type":"cms_article"


                expect(@activityStream.matchActivity(message)).not.to.be.ok
                done()

            it "Match activities activities of the same user and same verb", (done) ->
                config =
                    filters: ['FAVORITED']
                    user:
                        type: 'mmdb_user',
                        id: 1

                @activityStream = new ActivityStreamModule()
                @activityStream.ready(config)
                expect(@activityStream).to.be.ok
                message =
                    "actor":
                        "data":
                            "api":"http://localhost/user/1",
                            "aid":"1",
                            "type":"db_user"
                    "verb":
                        "type":"FAVORITED"
                    "object":
                        "data":
                            "api":"//otherpage/api/v1/article/1/",
                            "aid":"1",
                            "type":"cms_article"

                expect(@activityStream.matchActivity(message)).to.be.ok
                done()

            it "Ignore activities of same user but a different verb", (done) ->
                config =
                    filters: ['FAVORITED']
                    user:
                        type: 'mmdb_user',
                        id: 1

                @activityStream = new ActivityStreamModule()
                @activityStream.ready(config)
                expect(@activityStream).to.be.ok
                message =
                    "actor":
                        "data":
                            "api":"http://localhost/user/1",
                            "aid":"1",
                            "type":"db_user"
                    "verb":
                        "type":"FOLLOWED"
                    "object":
                        "data":
                            "api":"http://localhost/user/2",
                            "aid":"2",
                            "type":"db_user"


                expect(@activityStream.matchActivity(message)).not.to.be.ok
                done()


            it "Match activities activities of the same user, verb and object type", (done) ->
                config =
                    filters: ['FAVORITED', 'cms_article']
                    user:
                        type: 'mmdb_user',
                        id: 1

                @activityStream = new ActivityStreamModule()
                @activityStream.ready(config)
                expect(@activityStream).to.be.ok
                message =
                    "actor":
                        "data":
                            "api":"http://localhost/user/1",
                            "aid":"1",
                            "type":"db_user"
                    "verb":
                        "type":"FAVORITED"
                    "object":
                        "data":
                            "api":"//otherpage/api/v1/article/1/",
                            "aid":"1",
                            "type":"cms_article"

                expect(@activityStream.matchActivity(message)).to.be.ok
                done()

            it "Ignore activities of same user and verb, but different type of object", (done) ->
                config =
                    filters: ['FAVORITED', 'cms_article']
                    user:
                        type: 'mmdb_user',
                        id: 1

                @activityStream = new ActivityStreamModule()
                @activityStream.ready(config)
                expect(@activityStream).to.be.ok
                message =
                    "actor":
                        "data":
                            "api":"http://localhost/user/1",
                            "aid":"1",
                            "type":"db_user"
                    "verb":
                        "type":"FAVORITED"
                    "object":
                        "data":
                            "api":"http://localhost/blog/2",
                            "aid":"2",
                            "type":"blog_post"

                expect(@activityStream.matchActivity(message)).not.to.be.ok
                done()

        describe "Logger Module", ->
            it "Can create a new instance of a Logger module", (done) ->
                @logger = new Logger()
                expect(@logger).to.be.ok
                done()

        describe "User Module", ->
            it "Can create a new instance of a User module", (done) ->
                @user = new User('mmdb_user', '1')
                expect(@user).to.be.ok
                done()

        describe "Mapper Module", ->
            data = {}
            map = {}
            TestMapper = undefined

            before (done) ->
                # Set up objects for test.
                testConfig =
                    api:
                        user:
                            map:
                                displayName: 'name'
                                imageMedium:
                                    photo:
                                        [ medium: "src" ]
                                imageMediumDisplayName:
                                    photo:
                                        [ medium: "name" ]
                                url: (obj) -> return "//example.com#{obj.path}"

                # Modify Mapper so that we can supply our own config
                class TestMapper extends Mapper
                    constructor: (type, object) ->
                        @type = type
                        @base = testConfig.api[@type].map
                        @map = {}
                        return @drill object

                data =
                    name: "Rap Cat",
                    photo: [
                        medium:
                            src: "http://o-dub.com/images/rapcat.jpg"
                            name: "rapping cat"
                    ]
                    path: "/rapcat"

                done()

            it "Can create a new instance of a Mapper module", (done) ->
                map = new TestMapper('user', data)
                expect(map).to.be.ok
                done()
            it "Can map strings", (done) ->
                expect(map.displayName).to.be.equal("Rap Cat")
                done()
            it "Can map properties in nested objects and arrays", (done) ->
                expect(map.imageMedium).to.be.equal("http://o-dub.com/images/rapcat.jpg")
                expect(map.imageMediumDisplayName).to.be.equal("rapping cat")
                done()
            it "Can map properties using functions", (done) ->
                expect(map.url).to.be.equal("//example.com/rapcat")
                done()
)()
