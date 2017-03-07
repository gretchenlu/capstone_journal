#Mar 5th

#   deleted_at most are nulls?
#opportunities <- opportunities[which(is.na(opportunities$deleted_at)==TRUE),] #get rid of deleted columns 
opportunities <- subset(opportunities, opportunities$version < 2) #want only 1st version
opportunities <- subset(opportunities, opportunities$is_renewal == 0)

#subset the opportunities table

select = c("uuid", "amount", "stage", "created_date", "customer_id", "opportunity_type", "close_date",
           "probability", "is_won", "source")
opportunities1 <- opportunities[, select]
colnames(opportunities1)[1] <- "opportunity_id"

#merge opportunities and customers
colnames(customers)[1] <- "customer_id"
select = c("customer_id", "customer_type", "industry", "shipping_city", "shipping_state", "shipping_country")
customers1 <- customers[, select]

op_cus <- merge(opportunities1, customers1, by.x = "customer_id", by.y = "customer_id")
str(op_cus)

#merge with products
products1 <- prod[, c("uuid", "family")]
colnames(products1)[1] <- "product_id"
oppor_prod1 <- oppor_prod[, c("opportunity_id", "product_id", "price", "quantity", "total")]
oppor_prod2 <- merge(oppor_prod1, products1, by = "product_id")
op_cus_prod <- merge(op_cus, oppor_prod2, by = "opportunity_id")

#merge with partners
partners1 <- par_oppor[, c("opportunity_id", "partner_id")]
op_cus_par <- merge(op_cus, partners1, by = "opportunity_id", all.x = TRUE)
