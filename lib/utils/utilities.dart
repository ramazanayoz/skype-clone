class XUtils {
  static String getUserName(String email) {
    print("before split: ${email}");
    print("after split: "+ email.split('@')[0] );
    return "live:${email.split('@')[0] }";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial; 
  }
}