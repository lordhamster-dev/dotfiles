sketchybar --set $NAME \
  label="Loading..." \
  icon.color=0xff5edaff

# fetch weather data
API_KEY="641f8ee5b4aee851b2fb5c9a32dbd37f"
CITY="上海"

# Line below replaces spaces with +
WEATHER_JSON=$(curl -s "https://api.98dou.cn/api/weather?apiKey=$API_KEY&city=$CITY")

# Fallback if empty
if [ -z $WEATHER_JSON ]; then
  sketchybar --set $NAME label="$CITY"
  return
fi

TEMPERATURE=$(echo $WEATHER_JSON | jq '.English.wendu' | tr -d '"')
STATE=$(echo $WEATHER_JSON | jq '.English.weatherstate' | tr -d '"')

sketchybar --set $NAME \
  label="$CITY $TEMPERATURE $STATE"
