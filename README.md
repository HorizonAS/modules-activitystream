module-activitystream
=====================

#Activity Stream front-end module

###Instalation:

1. First as always is necessary to clone the repo:
         
         git clone git@github.com:natgeo/modules-activitystream.git

2. Make sure you have ruby installed by running:

        ruby -v

3. Then install sass by running: 

        gem install sass 
     

*For linux users use sudo*

4. Then execute:

        bundle 
     If bundle install fails, then try executing: 
     
         gem install bundler
    
    *For linux users use sudo*

5. Run: 

        npm install

6. Then: 

        bower install  
     
     If this fails probably you need to execute 
     
             sudo npm install -g bower 
     
     This will install bower globally

7. You can try running: 

        grunt serve 
     
     *If grunt is not installed then execute:*
     
             sudo npm install -g grunt-cli
     
     *The same with bower, this will install grunt globally.*
