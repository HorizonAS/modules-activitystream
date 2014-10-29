(->
    "use strict"

    Activity = undefined
    ActivityStreamModule = undefined
    Logger = undefined
    User = undefined
    Mapper = undefined
    FilterManager = undefined
    Routing = undefined

    before (done) ->
        require [
            "modules/activity",
            "modules/activityStream",
            "modules/logger",
            "modules/user"
            "modules/mapper"
            "modules/filterManager"
            "modules/routing"
        ],(_Activity, _ActivityStreamModule, _Logger, _User, _Mapper, _FilterManager, _Routing) ->
            Activity = clone(_Activity)
            ActivityStreamModule = clone(_ActivityStreamModule)
            Logger = clone(_Logger)
            User = clone(_User)
            Mapper = clone(_Mapper)
            FilterManager = clone(_FilterManager)
            Routing = clone(_Routing)
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

        describe "FiltersManager Module", ->

            it "Match activities of the actor", (done) ->
                config =
                    actor: 'db_user/1'

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

                @filterManager = new FilterManager()
                @filterManager.addFilters(config)
                expect(@filterManager.matchActivity(message)).to.be.ok
                done()

            it "Ignore activities of other actor", (done) ->
                config =
                    actor: 'db_user/1'

                message =
                    "actor":
                        "data":
                            "api":"http://localhost/user/1",
                            "aid":"2",
                            "type":"db_user"
                    "verb":
                        "type":"FAVORITED"
                    "object":
                        "data":
                            "api":"http://localhost/blog/2",
                            "aid":"2",
                            "type":"blog_post"

                @filterManager = new FilterManager()
                @filterManager.addFilters(config)
                expect(@filterManager.matchActivity(message)).to.be.not.ok
                done()


        describe "Routing Module", ->
            describe 'Given actor_type=db_user and actor_aid=1', () ->
                it 'returns /actor/db_user/1/activities', (done) ->
                    @routing = new Routing()
                    url = @routing.urlForContext({actor_aid: 1, actor_type: 'db_user'})
                    expect(url).to.be.contain('/actor/db_user/1/activities')
                    done()


            describe 'Given object_type=db_user and object_aid=1', () ->
                it 'returns /object/db_user/1/activities', (done) ->
                    @routing = new Routing()
                    url = @routing.urlForContext({object_aid: 1, object_type: 'db_user'})
                    expect(url).to.be.contain('/object/db_user/1/activities')
                    done()

            describe 'Given actor_type=db_user, actor_aid=1 and verb_type=FOLLOWING', () ->
                it 'returns /actor/db_user/1/FOLLOWING', (done) ->
                    @routing = new Routing()
                    url = @routing.urlForContext({actor_aid: 1, actor_type: 'db_user', verb_type: 'FOLLOWING'})
                    expect(url).to.be.contain('/actor/db_user/1/FOLLOWING')
                    done()

            describe 'Given object_type=db_user, object_aid=1, verb_type=FOLLOWING and object_type=blog_article', () ->
                it 'returns /actor/db_user/1/FOLLOWING/blog_article', (done) ->
                    @routing = new Routing()
                    url = @routing.urlForContext({actor_aid: 1, actor_type: 'db_user', verb_type: 'FOLLOWING', object_type: 'blog_article'})
                    expect(url).to.be.contain('/actor/db_user/1/FOLLOWING/blog_article')
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
