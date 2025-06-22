public class ContactTriggerHandler {
	public static void checkDuplicateEmails(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        Set<String> emailSet = new Set<String>();

        // Collect new/changed emails
        for (Contact c : newContacts) {
            // For update, only check if email has changed
            if (Trigger.isUpdate && c.Email == oldMap.get(c.Id).Email) {
                continue;
            }
            if (String.isNotBlank(c.Email)) {
                emailSet.add(c.Email.toLowerCase());
            }
        }

        // Query existing contacts with same emails (excluding current records)
        Map<String, Contact> existingEmailMap = new Map<String, Contact>();

        if (!emailSet.isEmpty()) {
            for (Contact existing : [
                SELECT Id, Email FROM Contact
                WHERE Email IN :emailSet
                AND Id NOT IN :newContacts
            ]) {
                existingEmailMap.put(existing.Email.toLowerCase(), existing);
            }
        }

        // Add errors to records with duplicate emails
        for (Contact c : newContacts) {
            if (String.isNotBlank(c.Email) && existingEmailMap.containsKey(c.Email.toLowerCase())) {
                c.Email.addError('Duplicate Email found: ' + c.Email);
            }
        }
    }
}