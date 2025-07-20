# Ubuntu + Java Base Image Exercises

This is the first image in our Big Data learning series. It provides a solid foundation with Ubuntu 22.04 and Java 11.

## Learning Objectives
- Verify Java installation and configuration
- Practice basic Linux commands
- Understand Docker container basics

## Exercise 1: Java Verification

1. **Run the verification script:**
   ```bash
   cd /home/hadoop/scripts
   ./verify-java.sh
   ```

2. **Expected Output:**
   - Java version should show OpenJDK 11
   - JAVA_HOME should be set to `/usr/lib/jvm/java-11-openjdk-amd64`
   - Simple Java program should compile and run successfully

## Exercise 2: Basic Linux Commands

1. **Check system information:**
   ```bash
   # Check Ubuntu version
   cat /etc/os-release
   
   # Check available memory
   free -h
   
   # Check disk space
   df -h
   
   # Check current user
   whoami
   ```

2. **File operations:**
   ```bash
   # Create a test directory
   mkdir ~/test-dir
   
   # Create a test file
   echo "Hello Big Data!" > ~/test-dir/hello.txt
   
   # List files
   ls -la ~/test-dir/
   
   # Read the file
   cat ~/test-dir/hello.txt
   ```

## Exercise 3: Java Programming Practice

1. **Create a simple Java program:**
   ```bash
   cat > ~/Calculator.java << 'JAVA_EOF'
   public class Calculator {
       public static void main(String[] args) {
           int a = 10;
           int b = 5;
           
           System.out.println("Addition: " + a + " + " + b + " = " + (a + b));
           System.out.println("Subtraction: " + a + " - " + b + " = " + (a - b));
           System.out.println("Multiplication: " + a + " * " + b + " = " + (a * b));
           System.out.println("Division: " + a + " / " + b + " = " + (a / b));
       }
   }
   JAVA_EOF
   ```

2. **Compile and run:**
   ```bash
   javac ~/Calculator.java
   java -cp ~ Calculator
   ```

3. **Clean up:**
   ```bash
   rm ~/Calculator.java ~/Calculator.class
   ```

## Verification Checklist

- [ ] Java 11 is installed and working
- [ ] JAVA_HOME environment variable is set correctly
- [ ] Can compile and run Java programs
- [ ] Basic Linux commands work as expected
- [ ] User 'hadoop' has sudo privileges

## Next Steps

Once you've completed these exercises successfully, you're ready to move on to the next image which will add Hadoop HDFS and YARN capabilities.

## Troubleshooting

**Issue: Java command not found**
- Solution: Check if JAVA_HOME is set correctly: `echo $JAVA_HOME`

**Issue: Permission denied**
- Solution: Make sure you're running as the hadoop user: `whoami`

**Issue: Script not executable**
- Solution: Make the script executable: `chmod +x /home/hadoop/scripts/verify-java.sh`
