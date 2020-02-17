#!R --vanilla
require(readODS)
setwd("~/tmp")
script.dir <- "~/proyectos/IUCN/RLE-xml-db/R"
source(sprintf("%s/RbaseXClient.R",script.dir))



Session <- BasexClient$new("localhost", 1984, "jferrer", readLines("~/.basexpwd"))
print(Session$command("info")$result)


## deletes and inserts only work when the database is not opened by another process

   test <- Session$command("OPEN init")
if (!test$success) {
  test <- Session$create("init", "<xml> <References/>
     <Case-studies/> </xml>")
  if (test$success) {cat( test$info, "\n")
  } else {
    cat("Could not create database\n")
  }
}
## this can be used to delete nodes in basexgui, if there are no other connections to the database:
##delete node //Reference

Ref.list <- read_ods("~/proyectos/IUCN/RLE-xml-db/input/RLE assessment summary tables.ods",sheet=1)

MinimumRef <- "
element Reference {
   attribute id {'%1$s'},
  element Ref-information {
    element ref-label { '%1$s' },
    element ref-titles {     element ref-title { attribute lang {'%2$s'}, '%3$s' }
     }
  }
}
"
for (k in 1:nrow(Ref.list)) {
   ref.label <- Ref.list$reference_code[k]
   ref.title <- Ref.list$Title[k]
   ref.lang <- Ref.list$language[k]
   if (any(c(ref.label,ref.title,ref.lang) %in% NA)) {
      cat(sprintf("Error with %s\n",k))
   }   else {

   Session$command(sprintf("xquery let $up := %s
    return
  insert node $up as last into db:open('init')//References",
   sprintf(MinimumRef,ref.label,ref.lang,ref.title)
   ))$result

   }
}

## ADD a node with basic information:

chile <- read_ods("~/proyectos/IUCN/RLE-xml-db/input/Summary_RLE_database.ods",sheet=2)
for (k in 1:nrow(chile)) {
  CS.name <- chile[k,3]
  CS.id <- sprintf("%s_%s",chile[k,"Reference"],chile[k,"ID"])
  Ocat <- chile[k,"Final"]
  Ref.label <- chile[k,"Reference"]
  addCS <- sprintf("element Case-Study {
    attribute name { '%1$s' },
    attribute id { '%2$s' },
    element Case-Study-Names {
      element Case-Study-Name { attribute lang { 'es' }, '%1$s' }
    },
    element Assessment-information {
      element Reference-label { '%4$s' }
    },
    element Assessment-target {
      element AT-id { '%2$s' }
    },
    element Ecosystem-Risk-Assessment {
      element Assessment-version { '2.0' },
      element Risk-assessment-protocol { 'IUCN RLE' },
      element Assessment-units {
        element Assessment-unit {
          element Overall-category { '%3$s' }
        }
      }
    }
  }",CS.name,CS.id,Ocat,Ref.label)
  Session$command(sprintf("xquery let $up := %s
    return
  insert node $up as last into db:open('init')//Case-studies",addCS))$result

}

## example xquery to produce a simple output:
Session$command(sprintf("xquery
for $ref in db:open('init')//Reference/@id
let $k := count(//Case-Study/Assessment-information[Reference-label=$ref])
order by $ref
return (
    <a>{$ref}</a>,<b>{$k}</b>
)"))



##Session$command("xquery /")$result
Session$command("xquery //Overall-category")$result



print(Session$command("list")$result)

##Session$command("DROP DB test2")
