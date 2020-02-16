let $up := element Reference {
  attribute ID { "Marchall_2018" },
  element Year { 2018 },
  element Authors {
    element Author { "Ashleigh Marshall" },
    element Author { "Henrike Schulte to Bühne" },
    element Author { "Lucie Bland" },
    element Author { "Nathalie Pettorelli" }
  },
  element Title { "Assessing ecosystem collapse risk in ecosystems dominated by foundation species: The case of fringe mangroves" },
  element DOI { "10.1016/j.ecolind.2018.03.076" }
}

return
insert node $up as last into db:open('init')//References

let $up := element Case-Study {
  attribute name { "Philippines’ fringe mangrove forests" },
  attribute id { "Marshall_2018_1" },
  element Assessment-target {
    element AT-id { "Marshall_2018_1" }
  },
  element Ecosystem-Risk-Assessment {
    element Assessment-version {"2.X"},
    element Risk-assessment-protocol {"IUCN RLE"},
    element Assessment-units {
      element Assessment-unit {
        element Overall-category { "LC" }
      }
    }
  }
}

  return
insert node $up as last into db:open('init')//Case-studies
