# get the package for connecting to LinkedIn
library(devtools)
install_github("mpiccirlli/Rlinkedin")
library(Rlinkedin)

# use my API and Secret Key for the package
app_name <- "DataScience"
consumer_key <- "754ibaadcitf6r"
consumer_secret <- "zZYmyr4KeeyVBLW4"
in.auth <- inOAuth(app_name, consumer_key, consumer_secret)

# get my profile
my.profile <- getProfile(in.auth)

# search for companies
key_word <- "computer software"
company <- searchCompanies(in.auth, "computer software")