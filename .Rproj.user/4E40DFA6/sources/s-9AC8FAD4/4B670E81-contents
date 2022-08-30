
# Инициация ####
# setwd("/Users/sgum/Yandex.Disk-work.drive@dtwin.ru.localized/1. PersData/1. ИП Гумеров/7. СП/4. ЦД  UP/2. Проекты/121.EurochemP/")
path <- "/8.VA/6.JavaClasses/StatModel/classes"

library(rJava)
library(ggplot2)
library(tidyverse)
library(plotly)


.jinit()
.jclassPath()
.jaddClassPath(paste0(getwd(),path))
.jclassPath()
stat.model <- .jnew("statmodel.StatModel")
str(stat.model)
.jconstructors(stat.model)
.jmethods(stat.model)
.jfields(stat.model)
.DollarNames(stat.model)

brent   <-read.table("8.VA/1.Data/brent.txt", header = FALSE, sep = " ")
coal    <-read.csv("8.VA/1.Data/coal.txt", header = FALSE)
gas     <-read.csv("8.VA/1.Data/gas.txt", header = FALSE, sep = " ")
euro    <-read.csv("8.VA/1.Data/euro.txt", header = FALSE, sep = " ")
GDP     <-read.csv("8.VA/1.Data/GDP.txt", header = FALSE, sep = " ") # Накопленным итогом
methanol<-read.csv("8.VA/1.Data/methanol.txt", header = FALSE, sep = " ")

# Вариант 1: МГК. Линейная регресионная модель ####
m <- 96 # Количество временных фактических периодов, в месяцах 8 лет. С 2012-2019
n <- 5  # Количество влияющих факторов (нефть, ...)
unit <- 1 #  Если 1 то добавляем константу в модель целевого показателя

{test <- GDP %>% cbind(V2 = seq(1, 3 * m)) %>% as_tibble()
  k <- ggplot(test, aes(y = V1, x = V2)) +
    geom_line()
  ggplotly(k)
}

stat.model$InitModel(as.integer(m), as.integer(n), as.integer(unit)) # Инициация модели
stat.model$FillX(as.integer(1), brent[1:m, 1]) # Заполняем модель фактическими значениями влияющих факторов
stat.model$FillX(as.integer(2), coal[1:m, 1])  
stat.model$FillX(as.integer(3), gas[1:m, 1])
stat.model$FillX(as.integer(4), euro[1:m, 1])
stat.model$FillX(as.integer(5), GDP[1:m, 1])
stat.model$FillY(methanol[1:m, 1])
R2 <- stat.model$CalcModel() # Создаем модель 

t <- c(1:m)
f <- methanol[1:m, 1] 
fCalc <- stat.model$GetCalc() # Получаем модельные значения ретроспективных значений
plot(t, f, type = "l")
lines(t, fCalc, col = "blue")


{
  model1 <- tibble(x = t, model = fCalc, fact = f) %>% 
    pivot_longer(cols = c(model, fact), names_to = "m")
  
  k2 <- ggplot(model1, aes(x = x, y = value, color = m)) +
    geom_line()
  
  ggplotly(k2)
}

# Строим прогнозы предикторов
mPred  <- length(brent[, 1])    # Количество известных-прогнозных значений по бренту и пр.
mKnown <- length(methanol[, 1]) # Количество известных значений по метанолу

stat.model$InitPredictor(as.integer(mPred), as.integer(mKnown))

stat.model$PredX(as.integer(1), brent[1:mPred, 1])
stat.model$PredX(as.integer(2), coal[1:mPred, 1])
stat.model$PredX(as.integer(3), gas[1:mPred, 1])
stat.model$PredX(as.integer(4), euro[1:mPred, 1])
stat.model$PredX(as.integer(5), GDP[1:mPred, 1])

stat.model$PredY(methanol[1:mKnown, 1])

stat.model$Forward() # Строим простую регресионная модель для метанола (на прогнозный период)
yPred <- stat.model$GetPredCalc() 

tp  <- c(1:mPred)
fp <- yPred
tk <- c(1:mKnown)
fk <- methanol[1:mKnown, 1]       

plot(tp, fp, type = "l", col = "red")
lines(tk, fk, col = "black")


{
  model21 <- tibble(x     = tp, 
                    fact  = c(fk, rep(NA, length(fp) - length(fk))), 
                    model = fp) %>% 
    pivot_longer(cols = c(model, fact), names_to = "m")
  
  k21 <- ggplot(model21, aes(x = x, y = value, color = m)) +
    geom_line()
  
  ggplotly(k21)
}

relErr <- stat.model$RelErr()
absErr <- stat.model$AbsErr() 
# Вариант 2: МГК. Регрессия зависящая от себя  ####
m <- 96
n <- 6 # Мы берем 6 факторов
unit <- 0

stat.model$InitModel(as.integer(m), as.integer(n), as.integer(unit))
stat.model$FillX(as.integer(1), brent[1:m, 1])
stat.model$FillX(as.integer(2), coal[1:m, 1])
stat.model$FillX(as.integer(3), gas[1:m, 1])
stat.model$FillX(as.integer(4), euro[1:m, 1])
stat.model$FillX(as.integer(5), GDP[1:m, 1])
stat.model$FillX(as.integer(6), methanol[1:m, 1]) #!!!!! Добавляем 6ю колонку про метанол

stat.model$FillY(methanol[1:(m + 1), 1], as.integer(1)) # Строим зависимость цены метанола, в том числе от предыдущего значения

R2 <- stat.model$CalcModel()

t <- c(1:m)
f <- methanol[1:m, 1]       
fCalc <- stat.model$GetCalc()
plot(t, f, type = "l")
lines(t, fCalc, col = "blue")

mPred  <- length(brent[, 1])
mKnown <- length(methanol[, 1])

stat.model$InitPredictor(as.integer(mPred), as.integer(mKnown)) # Добавляем прогнозы по сурьевым показателям

stat.model$PredX(as.integer(1), brent[1:mPred, 1])
stat.model$PredX(as.integer(2), coal[1:mPred, 1])
stat.model$PredX(as.integer(3), gas[1:mPred, 1])
stat.model$PredX(as.integer(4), euro[1:mPred, 1])
stat.model$PredX(as.integer(5), GDP[1:mPred, 1])

stat.model$PredY(methanol[1:mKnown, 1])

# Вариант 2.1 Строим прогноз от первого значения стоимости метанола            #### 

stat.model$Feedback(as.integer(6))
yPred <- stat.model$GetPredCalc()

tp  <- c(1:mPred)
fp <- yPred
tk <- c(1:mKnown)
fk <- methanol[1:mKnown, 1]       

plot(tp, fp, type = "l", col = "red")
lines(tk, fk, col = "black")

{
  model3 <- tibble( x     = tp, 
                    fact  = c(fk, rep(NA, length(fp) - length(fk))), 
                    model2 = fp) %>% 
    pivot_longer(cols = c(model2, fact), names_to = "m")
  
  k3 <- ggplot(model3, aes(x = x, y = value, color = m)) +
    geom_line()
  
  ggplotly(k3)
}

# Вариант 2.2: Строим прогноз от каждого известного значения стоимости метанола ####
stat.model$PredY(methanol[1:mKnown, 1])

stat.model$Feedback(as.integer(6), as.integer(mKnown))
yPred <- stat.model$GetPredCalc()

tp  <- c(1:mPred)
fp <- yPred
tk <- c(1:mKnown)
fk <- methanol[1:mKnown, 1]       

plot(tp, fp, type = "l", col = "red")
lines(tk, fk, col = "black")

relErr <- stat.model$RelErr()
absErr <- stat.model$AbsErr() 

nmPC <- stat.model$NmPrComp() # Количество главных компонент
pc  <- stat.model$PrComp()    
pc1 <- matrix(pc, 6, nmPC)    # Матрица главных компонент

{
  model4 <- tibble( x     = tp, 
                    fact  = c(fk, rep(NA, length(fp) - length(fk))), 
                    model3 = fp) %>% 
    pivot_longer(cols = c(model3, fact), names_to = "m")
  
  k4 <- ggplot(model4, aes(x = x, y = value, color = m)) +
    geom_line()
  
  ggplotly(k4)
}

# Модели все ####

{
  modelall <- rbind(model4, model3 %>% filter(m != "fact"), model21 %>% filter(m != "fact")) %>% 
    arrange(x) %>% 
    print()
  
  kall <- ggplot(modelall, aes(x = x, y = value, color = m)) +
    ggtitle("Прогнозные расчеты цены метанола на разных моделях")+
    xlab("Время") + 
    ylab("Цены, USD") + 
    theme(text = element_text(family = "Panton"))+
    geom_line(size = 0.3, alpha = 0.8)
  
  ggplotly(kall)
}

