# Load necessary libraries
library(DBI)
library(RSQLite)
library(dbplyr)
library(dplyr)


setwd("~/Documents/MEDS/Courses/eds213/bren-meds213-class-data/week7")

# Connect to the SQLite database
conn <- DBI::dbConnect(RSQLite::SQLite(), "database.db")


# Load the necessary tables into R as tbl objects
bird_eggs <- tbl(conn, "Bird_eggs")
bird_nests <- tbl(conn, "Bird_nests")
personnel <- tbl(conn, "Personnel")

# Join the Bird_eggs and Bird_nests tables by 'Nest_ID'
eggs_and_nests <- bird_eggs %>% 
  inner_join(bird_nests, by = 'Nest_ID') 

# Count the number of eggs measured by each observer
egg_counts <- eggs_and_nests %>%
  group_by(Observer) %>%
  summarise(total_eggs = n())

# Get the top 3 observers
top_observers <- egg_counts %>%
  arrange(desc(total_eggs)) %>%
  head(3)

# Add the observer names from the Personnel table
top_observers_with_names <- top_observers %>% 
  left_join(personnel, by = c('Observer' = 'Abbreviation'))

# Print the result
print(top_observers_with_names)

# Show the SQL query
show_query(top_observers_with_names)
