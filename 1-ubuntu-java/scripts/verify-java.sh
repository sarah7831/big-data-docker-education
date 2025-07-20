#!/bin/bash

echo "=== Java Installation Verification ==="
echo

echo "1. Checking Java version:"
java -version
echo

echo "2. Checking Java compiler version:"
javac -version
echo

echo "3. Checking JAVA_HOME:"
echo "JAVA_HOME = $JAVA_HOME"
echo

echo "4. Checking PATH includes Java:"
echo "PATH = $PATH"
echo

echo "5. Testing simple Java compilation:"
cat > HelloWorld.java << 'JAVA_EOF'
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Big Data World!");
        System.out.println("Java is working correctly!");
    }
}
JAVA_EOF

javac HelloWorld.java
java HelloWorld
rm HelloWorld.java HelloWorld.class

echo
echo "=== Java verification completed successfully! ==="
