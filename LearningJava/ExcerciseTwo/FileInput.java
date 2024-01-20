import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * An iterator type class to read values from a text file.  This is a subclass of
 * <code>Input</code> that hides the exceptions that can happen when opening a file.  As with
 * <code>Input</code> all errors during use of the iterator result in a message output to the
 * standard error and default values returned. If a file cannot be opened the program is terminated.
 * <p/>
 * <p>This class is useful for people new to Java since it allows them to write programs using
 * input from a file without having to fully understand the read / parse / handle exceptions model
 * of the standard Java classes.  Once exceptions and object chaining are covered this class
 * ought not to be used, it is definitely just an "early stepping stone" utility class for initial
 * learning.</p>
 *
 * Original Author
 * @author Russel Winder
 * Current Version
 * @version 2024-01-01
 */
public class FileInput extends Input
{
    /**
     * Construct <code>FileInput</code> object given a file name.
     */
    public FileInput(final String fileName)
    {
        try
        {
            scanner = new Scanner(new FileInputStream(fileName));
        }
        catch (FileNotFoundException fnfe)
        {
            System.err.println("File " + fileName + " could not be found.");
            System.exit(1);
        }
    }

    /**
     * Construct <code>FileInput</code> object given a file name.
     */
    public FileInput(final FileInputStream fileStream)
    {
        super(fileStream);
    }

    /**
     * @return true if the named file exists, else false.
     * The fileName can be either relative or absolute.
     */
    public static boolean exists(final String fileName)
    {
        return new File(fileName).exists();
    }
}