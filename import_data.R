rm(list = ls())
setwd("/Users/PC/Desktop/channeleyes/RPI_Capstone_2017_Data_Files")
activities <- read.csv("RPI_Capstone_2017_Activities.csv")
customers <- read.csv("RPI_Capstone_2017_Customers.csv")
licensees <- read.csv("RPI_Capstone_2017_Licensees.csv")
opportunities <- read.csv("RPI_Capstone_2017_Opportunities.csv")

oppor_history <- read.csv("RPI_Capstone_2017_Opportunity_Histories.csv")

partner <- read.csv("RPI_Capstone_2017_Partners.csv")
oppor_prod <- read.csv("RPI_Capstone_2017_Opportunity_Line_Items.csv")
par_oppor <- read.csv("RPI_Capstone_2017_Partner_Opportunities.csv")
prod <- read.csv("RPI_Capstone_2017_Products.csv")
head(activities)
str(opportunities)
str(licensees)
str(oppor_history)

#inner join opportunities and oppor_history
op_his <- merge(opportunities, oppor_history, by.x = "uuid", by.y = "opportunity_id")
#op_his$uuid <- as.character(op_his$uuid)
str(op_his)
#uuid1 is the last 8 digits of uuid
op_his$uuid1 <- lapply(as.character(op_his$uuid), function(x){substr(x, 30, 37)})

#smaller is the dataframe contains the variables of interest
smaller <- op_his[, c("uuid1", "stage.x", "close_date.x","stage.y", "amount.x", "probability.y", "close_date.y")]
str(smaller)
smaller$close_date.y <- as.Date(smaller$close_date.y, format="%Y-%m-%d")

#convert all columns to dataframe and not including list, so we can implement order function
smaller2 <- as.data.frame(lapply(smaller, unlist))  
str(smaller2)
#smaller3 is ordered by close_date.y for each opportunity, which is easier to understand
smaller3 <- smaller2[ order(smaller2[,1], smaller2[,7]), ]
#maybe need to convert the close_date.x to be in the same format with close_date.y

# ==========================================================
# Feb. 25th

colnames(opportunities)[1] <- "opportunity_id"
colnames(activities)[1] <- "activity_id"
#!!! op_act has a lot less records than opoortunities table 
# op_act <- merge(opportunities, activities, by.x = "opportunity_id", by.y = "opportunity_id")
# colnames(op_act)[1] <- "opportunity_id"
# colnames(op_act) <- c("opportunity_id", "name.oppor", "amount.oppor", "stage.oppor", "created_date.oppor",
#                      "last_modified_date.oppor", "customer_id", "opportunity_type", "close_date.oppor",
#                      "probability.oppor", "is_closed", )
# str(customers)
# op_act_cus <- merge(op_act, customers, by.x = "customer_id", by.y = "opportunity_id")


#merge opportunities and customers
colnames(customers)[1] <- "customer_id"
op_cus <- merge(opportunities, customers, by.x = "customer_id", by.y = "customer_id")
str(op_cus)

#take care of the columns with duplicate name
colnames(op_cus) <- c("customer_id", "opportunity_id", "name.opportunites", "amount", "stage.opportunities",
                      "created_date.opportunities", "last_modified_date.opportunities", "opportunity_type", 
                      "close_date.opportunities", "probability.opportunities", "is_closed.opportunities",
                      "is_won.opportunities", "source", "deleted_at.opportunities", "created_at.opportunities",
                      "updated_at.opportunities", "is_renewal", "version", "is_transactional", "last_activity_date",
                      "name.customers", "customer_type", "industry", "billing_city", "billing_country", 
                      "shipping_city", "shipping_state", "shipping_country", "created_date.customers", "last_modified_date.customers",
                      "deleted_at.customers", "created_at.customers", "updated_at.customers")


#merge op_cus with partners
