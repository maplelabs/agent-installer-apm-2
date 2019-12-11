#!/bin/bash
curl -X POST "localhost:8585/api/config" -d @input_config.json -H "Content-Type: application/json"
