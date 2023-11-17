use context essentials2021
include gdrive-sheets
include data-source
include shared-gdrive(
"dcic-2021",
"1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")


#Variabler for energy-per-day
#energy-per-unit-of-fuel = 10
#distance-travelled-per-day = 10
#distance-per-unit-of-fuel = 5 

#energy-per-day = ( distance-travelled-per-day / 
#                            distance-per-unit-of-fuel ) * 
#                                       energy-per-unit-of-fuel

# get table from gdrive and sanitize to string
ssid = "1E5OpKU9SdXoVnUQ7c4B-54muNDNHjgiWJ2sCOZIn1U4"
kWh-wealthy-consumer-data =
load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("Sheet1", true)
sanitize komponent using string-sanitizer
sanitize energi using string-sanitizer
  end

# funcsion to change from dtring to number
fun energi-to-number(str :: String) -> Number:
# skriv koden her (tips: bruk cases og string-to-number funksjonen)
  doc: "If s is not a numeric string, default to 0."
  cases(Option) string-to-number(str):
    | some(a) => a
    | none =>  1 # energy-per-day
  end

where:
  # energi-to-number("") is energy-per-day
  energi-to-number("40") is 40
end

#  using funcsion and to transform the column
transform-energi-newtable = transform-column(kWh-wealthy-consumer-data, "energi", 
energi-to-number)

# sum
sumtable = sum(transform-energi-newtable, "energi")



#add sum in table
table-sum = table: komponent :: String, energi :: Number
  row: "sumtable", sumtable
end

#to print table with ny row + sum
ny-row = get-row(table-sum, 0)
table1 = add-row(transform-energi-newtable, ny-row)

#to show bar-chart
#bar-chart(transform-energi-newtable, "komponent", "energi")
bar-chart(table-sum, "komponent", "energi")
bar-chart(table1, "komponent", "energi")

