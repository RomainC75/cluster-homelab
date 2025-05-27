# network dependency

<- dependency direction

VPC <- GW <- Route -> Route-Table

VPC <- SG <- SG-Rule

    -> group parameter
RDS -> option group
    -> subnet group -> subnet