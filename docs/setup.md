# Setting up LILA

## Overview
Since LILA is a pl/sql package, only a few steps are required for commissioning and use.

Ultimately, three database objects are required:
* Two Tables
* One Sequence

In order to perform logging, the schema user must also have the necessary rights.
As a rule, these rights should already exist, as LILA is only an addition to existing PL/SQL packages.

## Login database schema
Within your preferred sql tool (e.g. sqlDeveloper) login to the desired schema.
All following steps will done in the same schema.


## Creating Sequence
First of all the Sequence for the process IDs must exist. Otherwise the packages (s. below) cannot be compiled.
Execute the following statement:
```sql

```

## Creating Package
Is done by copy&paste and execute
1. Within your preferred sql tool (e.g. sqlDeveloper) login to the desired schema
2. Copy the complete content of lila.pks (the specification) into your preferred sql tool (e.g. sqlDeveloper) and execute the sql script
4. Copy the complete content of lila.pkb (the body) and execute the sql script
   * Perhaps an error occurs, 
6. Open the new package LILA (perhaps you have to refresh the object tree in your sql tool)
7. 

###

## Sequence


## Trouble shooting

GRANT CREATE SESSION TO LILA_USER;
GRANT CREATE TABLE TO LILA_USER;      -- Wichtig für DDL im Package
GRANT CREATE PROCEDURE TO LILA_USER;  -- Um Packages zu erstellen

### Sequence
### Tables
