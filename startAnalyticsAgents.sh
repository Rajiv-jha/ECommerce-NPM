#! /bin/bash
echo "Starting machine agent on web container..."; docker exec web /start-analytics-agent.sh; echo "Done"
echo "Starting machine agent on web1 container..."; docker exec web1 /start-analytics-agent.sh; echo "Done"
