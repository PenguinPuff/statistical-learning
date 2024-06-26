---
title: "LEGO"
format: 
  html:
    embed-resources: true
---

### Packages

We'll use the **tidyverse** package for much of the data wrangling and visualization.
The __tidyverse__ package should be installed by now on your computer. If not, take again a look at the [Set Up tutorial](https://learnr-examples.shinyapps.io/ex-setup-r/#section-install-packages). 
You can load the __tidyverse__ with the following command:

```{r}
#| label: load-packages
#| message: false
library(tidyverse)
```

## Data

The data is contained in the file `lego.csv` and can be found on Moodle in the folder *Data files, Quarto files and Solutions to previous problem sets*.

It is simulated data based on real prices for LEGO sales in 2018 in the United States. Names and hobbies have been randomly generated. The dataset contains the following variables.

| Variable    | Description |
| -------- | ------- |
| `first_name` | First name of customer |
| `last_name` | Last name of customer |
| `age`  | Age of customer |
| `phone_number` | Phone number of customer |
| `set_id` | Set ID of LEGO set purchased | 
| `number` | Item number of LEGO set purchased |
| `theme` | Theme of LEGO set purchased |
| `subtheme` | Sub theme of LEGO set purchased |
| `year` | Year of purchase |
| `name` | Name of LEGO set purchased |
| `pieces` | Number of pieces of LEGOs in set purchased |
| `us_price` | Price of the set purchased in US Dollars |
| `quantity` | Quantity of LEGO set(s) purchased |



## Solutions




::: {#sol-1}

Save the data and the starter file appropriately so the following code works.



```{r}
#| label: readin-data
#| message: false
#| eval: true
lego <- read_csv("data/lego.csv")
```

  *Remark:* Don't forget to remove `eval: false` or change it to  `eval: true`.

  Take a glimpse at the data.

```{r}
#| eval: false
lego
```

:::  




::: {#sol-2}

In this sample, the first three common names of purchasers are Jackson, Jacob and Joseph

```{r}
#| eval: false
lego |> 
  select(first_name) |>
  count(first_name) |>
  arrange(desc(n)) |>
  slice(1:3)
  
```



:::  






::: {#sol-3}

Removed all the observations with a missing value (NA) for subtheme

```{r}
lego <- lego |> 
  drop_na(subtheme)
```


:::  


__REMARK:__ Use the reduced dataset to answer the following questions.



::: {#sol-4}

Top 3 themes: Starwars, Gear, Mixels. Now we can filter these and find the most common subthemes in the respective themes!

```{r}
lego |>
  select(theme) |>
  count(theme) |>
  arrange(desc(n)) |>
  slice(1:3)

  
```

The most common subtheme in Starwars is: The Force Awakens
The most common subtheme in Gear are:  Role-Play toys	and Stationery
The most common subtheme in Mixels is: Series 9

```{r}
lego |>
  group_by(theme) |>
  filter(theme == "Star Wars" | theme == "Gear" | theme == "Mixels" ) |>
  count(subtheme)|>
  distinct(subtheme, n) |>
  arrange(desc(n))

```


:::  


::: {#sol-5}

Added the age_group column!

```{r}
lego <- lego |> 
  mutate(
    age_group = case_when(age <= 18 ~ "18 and under", age >= 19 & age <= 25 ~ "19-25", age >= 26 & age <= 35 ~ "26-35", age >= 36 & age <= 50 ~ "36-50", age >= 51 ~ "51 and over")
  )
```
:::  




::: {#sol-6}

The age group that has purchased the highest number of LEGO sets is 36-50

```{r}
lego |> 
  group_by(age_group) |>
  count(quantity)|>
  summarize(total_quantity = sum(n*quantity)) |>
  arrange(desc(total_quantity))

  
```


:::  





::: {#sol-7}


```{r}
lego |> 
  filter(theme == "City" | theme == "Nexo Knights" | theme == "Ninjago") |> 
  ggplot(aes(x = theme , fill = age_group))+
  geom_bar()+
  scale_fill_brewer(palette = "Set1") +
  labs(
    x = "Popular LEGO theme", y = "count", fill = "Age group", title = "Distribution of age within each of the three popular themes"
  )


```

Between the variables `theme` and `age_group`, age groups "18 and under" and "19-25" have purchased way lesser number of lego sets as compared "26-35", "36-50" and "51 and above" so we can establish an association that "an older person has more chance of having more lego sets as compared to a younger one" 

:::  




::: {#sol-8}

The age group which has invested the most money on LEGO sets is 36-50

```{r}
lego |> 
  group_by(age_group) |>
  mutate(total_cost = us_price * quantity) |>
  summarize(expenditure = sum(total_cost)) |>
  arrange(desc(expenditure))


```

:::  




::: {#sol-9}

The number of observations from 36-50 age group and have been buying either a set from the Star Wars or the Ninjago theme: 9


```{r}
lego |>
  filter(theme == "Star wars" | theme == "Ninjago" & age_group == "36-50") |>
  count()

```
