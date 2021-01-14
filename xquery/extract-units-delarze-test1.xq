for $x in //Case-Study
where $x/ref-label="CH_RL_Lebensraeume_2016"
let $y := $x/assessment-target
return string-join((data($y/ecosystem-id),
  data($y/name),
  data($y/original-name),
  data($y/assessment-unit/Risk-Assessment/overall-category)),",")
