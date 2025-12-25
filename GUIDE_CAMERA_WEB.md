# Guide : Activer la caméra dans l'application web

## 🔍 Problème : La boîte de dialogue de fichier s'ouvre au lieu de la caméra

Si vous voyez une boîte de dialogue "Ouvrir" au lieu de la caméra, voici comment résoudre le problème :

## ✅ Solutions

### 1. Vérifier que vous êtes sur localhost ou HTTPS

L'API de caméra du navigateur nécessite :
- **HTTPS** (pour les sites en production)
- **localhost** (pour le développement local)

**Vérification :**
- L'URL doit commencer par `http://localhost` ou `https://`
- Si vous êtes sur `http://192.168.x.x` ou une autre IP, la caméra ne fonctionnera pas

### 2. Autoriser les permissions de caméra dans le navigateur

**Chrome/Edge :**
1. Cliquez sur l'icône de cadenas (🔒) dans la barre d'adresse
2. Cliquez sur "Paramètres du site"
3. Trouvez "Caméra" et sélectionnez "Autoriser"
4. Rechargez la page

**Firefox :**
1. Cliquez sur l'icône de cadenas (🔒) dans la barre d'adresse
2. Cliquez sur "Plus d'informations"
3. Dans "Permissions", trouvez "Utiliser la caméra" et sélectionnez "Autoriser"
4. Rechargez la page

### 3. Vérifier que la caméra n'est pas utilisée par une autre application

- Fermez toutes les autres applications qui utilisent la caméra (Zoom, Teams, Skype, etc.)
- Redémarrez le navigateur si nécessaire

### 4. Tester l'accès à la caméra

Ouvrez la console du navigateur (F12) et testez :

```javascript
navigator.mediaDevices.getUserMedia({ video: true })
  .then(stream => {
    console.log('Caméra accessible !');
    stream.getTracks().forEach(track => track.stop());
  })
  .catch(error => {
    console.error('Erreur:', error);
  });
```

### 5. Vérifier les paramètres Windows

**Windows 10/11 :**
1. Ouvrez "Paramètres" → "Confidentialité" → "Caméra"
2. Assurez-vous que "Autoriser les applications à accéder à votre caméra" est activé
3. Vérifiez que votre navigateur est autorisé

## 🎯 Utilisation

Une fois la caméra activée :

1. **Allez sur la page Profil** dans l'application web
2. **Cliquez sur l'icône caméra** (📷) sur l'avatar
3. **Autorisez l'accès** si le navigateur le demande
4. **La caméra s'ouvre** dans une fenêtre modale
5. **Cliquez sur "Capturer"** pour prendre la photo
6. **La photo s'affiche** dans votre avatar

## 🐛 Messages d'erreur courants

### "Permission refusée"
→ Autorisez l'accès à la caméra dans les paramètres du navigateur

### "Aucune caméra trouvée"
→ Vérifiez que votre caméra est connectée et fonctionne

### "La caméra est déjà utilisée"
→ Fermez les autres applications qui utilisent la caméra

### "Votre navigateur ne supporte pas l'accès à la caméra"
→ Utilisez Chrome, Firefox ou Edge (versions récentes)

## 📝 Note importante

- La caméra fonctionne uniquement sur **localhost** ou **HTTPS**
- Certains navigateurs peuvent demander l'autorisation à chaque fois
- La caméra frontale est utilisée par défaut pour faciliter la capture du visage

