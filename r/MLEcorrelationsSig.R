require(cocor) # load package


#Metacognitive Efficiency MLE:

##Overlapping pairs: 
#Memory+Calories and Memory+GDP
cocor.dep.groups.overlap(r.jk=+0.57, r.jh=+0.32, r.kh=+0.33, n=330,
                         alternative="two.sided", alpha=0.05, conf.leve=0.95, 
                         null.value=0)

#Memory+Calories and Memory+Vision
cocor.dep.groups.overlap(r.jk=+0.57, r.jh=+0.37, r.kh=+0.39, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Memory+Calories and Calories+GDP
cocor.dep.groups.overlap(r.jk=+0.57, r.jh=+0.33, r.kh=+0.32, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Memory+Calories and Calories+Vision
cocor.dep.groups.overlap(r.jk=+0.57, r.jh=+0.39, r.kh=+0.37, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Memory+Vision and Vision+GDP
cocor.dep.groups.overlap(r.jk=+0.37, r.jh=+0.22, r.kh=+0.32, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Memory+Vision and Vision+Calories
cocor.dep.groups.overlap(r.jk=+0.37, r.jh=+0.39, r.kh=+0.57, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Memory+Vision and Memory+GDP
cocor.dep.groups.overlap(r.jk=+0.37, r.jh=+0.32, r.kh=+0.22, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)


#Memory+GDP and Calories+GDP
cocor.dep.groups.overlap(r.jk=+0.32, r.jh=+0.33, r.kh=+0.57, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Memory+GDP and Vision+GDP
cocor.dep.groups.overlap(r.jk=+0.32, r.jh=+0.22, r.kh=+0.37, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)
#Vision+Calories and GDP+Vision
cocor.dep.groups.overlap(r.jk=+0.39, r.jh=+0.22, r.kh=+0.33, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

#Vision+Calories and Calories+GDP
cocor.dep.groups.overlap(r.jk=+0.39, r.jh=+0.33, r.kh=+0.22, n=330,
                         alternative="two.sided", alpha=0.05, conf.level=0.95, 
                         null.value=0)

!!!!!
#Vision+GDP and Calories+GDP
#cocor.dep.groups.overlap(r.jk=+0.22, r.jh=+0.33, r.kh=+0.39, n=330,
 #                        alternative="two.sided", alpha=0.05, conf.level=0.95, 
  #                       null.value=0)
!!!!!

##Non Overlapping pairs: 

#Memory+GDP and Calories+Vision
cocor.dep.groups.nonoverlap(r.jk=+0.32, r.hm=+0.39, r.jh=+0.57, r.jm=+0.37, 
                            r.kh=+0.33, r.km=+0.22, n=330, alternative="two.sided",
                            alpha=0.05, conf.level=0.95, null.value=0)

#Memory+Vision and CAlories+GDP
cocor.dep.groups.nonoverlap(r.jk=+0.37, r.hm=+0.33, r.jh=+0.57, r.jm=+0.32, 
                            r.kh=+0.39, r.km=+0.22, n=330, alternative="two.sided",
                            alpha=0.05, conf.level=0.95, null.value=0)

#Memory+Calories and Vision+GDP
cocor.dep.groups.nonoverlap(r.jk=+0.57, r.hm=+0.22, r.jh=+0.37, r.jm=+0.32, 
                            r.kh=+0.39, r.km=+0.33, n=330, alternative="two.sided",
                            alpha=0.05, conf.level=0.95, null.value=0)

