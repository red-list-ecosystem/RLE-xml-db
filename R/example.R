
source("RbaseXClient.R")

Session <- BasexClient$new("localhost", 1984, "admin", "admin")
print(Session$command("info")$result)


test <- Session$create("init", "")

   test <- Session$command("OPEN init")
if (!test$success) {
  test <- Session$create("init", "<xml> <References/>
     <Case-studies/> </xml>")
  if (test$success) {cat( test$info, "\n")
  } else {
    cat("Could not create database\n")
  }
}

MinimumRef <- "
element Reference {
  element Ref-information {
    element ref-label { '%1$s' },
    element ref-titles {     element ref-title { attribute lang {'%2$s'}, '%3$s' }
     }
  }
}
"
ref.label <- ""
ref.title <- ""
sprintf(MinimumRef,ref.label,"en",ref.title)

## ADD a node with basic information:
require(readODS)
chile <- read_ods("../input/Summary_RLE_database.ods",sheet=2)
for (k in 1:nrow(chile)) {
  CS.name <- chile[k,3]
  CS.id <- sprintf("%s_%s",chile[k,"Reference"],chile[k,"ID"])
  Ocat <- chile[k,"Final"]
  Ref.label <- chile[k,"Reference"]
  addCS <- sprintf("element Case-Study {
    attribute name { '%1$s' },
    attribute id { '%2$s' },
    element Case-Study-Names {
      element Case-Study-Name { attribute lang { 'en' }, '%1$s' }
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



##Session$command("xquery /")$result
Session$command("xquery //Overall-category")$result



print(Session$command("list")$result)

##Session$command("DROP DB test2")
