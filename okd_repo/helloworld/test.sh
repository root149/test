sleep 5
if curl web | grep -q 'app.py'; then
 echo "Tests passed!"
 exit 0
else
 echo "Tests failed!"
 exit 1
fi
