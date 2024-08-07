# Bike Sales Analytics - Using Enterprise Data Models
## Description

**Overview**: This project demonstrates how transactional data ingested from POS systems into an on-prem relational database can be modeled and loaded onto a fully-managed cloud data warehouse for efficient querying and analysis by various departments in a firm. I used an ELT process to load and transform the data right in the warehouse. The OLAP (Online Analytical Processing) model which is used for reporting can be broken down into various layers. Rather than sticking to a pure Kimball or Inmon warehousing approach, I decided to build the foundation of the OLAP model using a Data Vault 2.0. It's layers can be defined as the following:
  - **Staging Layer:** This layer consists of raw data collected by the point of transaction. In this project, this data is stored locally in a relational model.
  - **Enterprise Data Warehouse Layer:** This layer builds the foundation of the data warehouse in this project. The Data Vault 2.0 model contains 3 types of entities: hubs, links, and satellites. Hubs store the primary (business) keys of each entity, link tables act as bridges which use a hash primary key that joins two hubs, and satellites store attributes of each entity. This layer also stores metadata of each record to keep track of changes. Data Testing/Validation is done here.
  - **Information Delivery Layer:** This layer uses the Data Vault as its backbone and transforms the vault entities into traditional fact/dimensions. It stores all transactional record keys in a large fact table, which is connected to its various dimensions via foreign keys. It also uses a special verison of the star schema (known as the snowflake schema) to normalize each product dimension into categories. This model is used by analysts in the front-end to answer business questions by efficiently querying against fact records and using joins to slice and dice by details.
  - **Presentation Layer:** This layer isn't necessarily a part of the data warehouse, but represents the analyst who runs queries against the data warehouse to develop reports and dashboards for their department (marketing, finance, sales, etc.). This layer denormalizes the snowflake normalized dimensions into a star schema to improve query performance in Power BI, and analyzes aggregate data using visuals and modifies them using slicers and filters.

**What's the point of using a Data Vault?**: Although sales data isn't the best example to show the benefits of making a complex structure such as the Data Vault in the warehousing stage, the model is best suited for firms who need to adapt to flexible data which can vary in size. It's also well suited for slowly changing dimensions, which signifies changes in a record's attributes after saved to memory (such as a customer's phone number). This can either be solved by overwriting the record (Type 1), creating a new record (Type 2), using a column in the records to keep original attribute (Type 3), or keeping a seperate history table that keeps all versions of that record (Type 4). 

The Data Vault solves this approach by seperating the business key from attributes subject to change, and stores those attributes in satellite tables. It also keeps track of load dates and other metadata, and contains optional tables such as PITs to keep track of historical attribute data. This method would minimize architecture and design complications which businesses have to deal with in order to keep all versions of a record's attributes.

**Limitations**: This model takes longer to design compared to traditional Kimball and Inmon warehouse designs, which more or less use traditional principles such as 3NF and denormalized schemas. Therefore, a firm implementing this strategy would have either have to account for the training of current specialists or outsource a data specialist experienced in this model. It also requires more work, as you still need to build a star or snowflake dimensional schema on top of this model as I have demonstrated.

Other limitations related to the project design itself includes a lack of ETL/ELT automation (uses SQL Server to export CSVs and load them manually into BigQuery), and no live connection to data from the reporting layer to BigQuery.

## Technology Used
**OLTP/Transactional Data**: To store the initial version of the data, I used **SQL Server** and interacted with the database to run the DDL queries for creating the entities using **SQL Server Management Studio**. You can swap it with any database you are familiar with, but it needs to be a relational database since the sample data is created using SQL CREATE and INSERT statements.
- **Installation**: Both can be downloaded and installed from Microsoft's website.

**Data Warehousing**: Since GCP's **BigQuery** has a sandbox feature for learning purposes, it provides a platform to create your entire data warehouse model in the cloud. It is also relatively simple to integrate with transformation tools for ELT pipelines such as dbt by accessing its API using your service account key. You can use any cloud data warehouse which can handle transformations performed inside of it.

**Data Transformation/Validation/Testing**: This project uses ELT to transform raw data right in the warehouse. This can be done using **dbt (data build tool)**, which connects to your warehouse and builds your data vault and dimensional model using SQL SELECT statements. The reason I used this tool is because it has packages such as AutomateDV to help build your data vault according to industry standards, minimizing poor design practices by someone who is new to this model. It also allows you to automate validation and testing using YAML files before creating production models. dbt has many tutorials and documentation to help you get started and connect to your data warehouse.

**Reporting/Analysis**: I personally use **Microsoft Power BI** for most reporting projects, as it is part of the Microsoft ecosystem and I have extensively learned its best practices through certifications. It also allows me denormalize some dimensions in Power Query by appending columns when loading in data. You can use any reporting tool you like that can easily ingest data (like Tableau) and that allows you transform the snowflake schema into a star schema and perform predictive analytics, descriptive analytics, and filter aggregate data. 
- **Installation**: The software and its tutorials can be found on the Microsoft website.

## How to Run
1. Install the on-premise software (SQL Server, SSMS, Power BI Desktop)
2. Run the queries for the bike sales sample database in SQL Server Management Studio
3. Create a matching schema of empty tables in BigQuery
4. Export the tables as CSV files into the matching tables
5. Connect dbt to your BigQuery warehouse and make data vault
6. Ensure validation and testing via YAML files in dbt on primary keys
7. Create dimensional model
8. Download CSV files of each fact/dimension and load into Power BI
9. Perform necessary modeling and transformations to develop report
10. Enforce RLS in Power BI as necessary





