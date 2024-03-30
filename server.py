import http.server
import socketserver

# Set the directory containing index.html
directory = '.'

# Set the port number for localhost
port = 8000  # Feel free to change this to any available port

# Combine a simple server with the specified directory and port
Handler = http.server.SimpleHTTPRequestHandler

# Launch the server
with socketserver.TCPServer(("", port), Handler) as httpd:
    print(f"Serving at http://localhost:{port}")
    # Activate the default web browser then point to localhost:port
    import webbrowser
    webbrowser.open(f'http://localhost:{port}')
    httpd.serve_forever()
