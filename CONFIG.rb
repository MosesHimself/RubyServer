#-Do your configuring here boys-#

PORT       = 17714

HOST       = "localhost"

MAXCLIENTS = 3

# Files will be served from this directory
WEB_ROOT = './public'

# Map extensions to their content type
CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt'  => 'text/plain',
  'png'  => 'image/png',
  'jpg'  => 'image/jpeg',
  'cgi'  => 'script/cgi',
  'rb'  => 'script/rb'
}

# Treat as binary data if content type cannot be found
DEFAULT_CONTENT_TYPE = 'application/octet-stream'
