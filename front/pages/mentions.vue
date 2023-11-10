<script setup lang="ts">
const menuItems = [
  {
    name: "scale",
    link: "#mentions",
    title: "Mentions Légales",
    icon: "scale",
  },
  {
    name: "clipboard",
    link: "#terms",
    title: "Termes et Conditions",
    icon: "clipboard",
  },
];
</script>

<template>
  <div class="flex">
    <AppSideBar :menu-items="menuItems">
      <template #icon-scale>
        <svg-icon name="scale" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-clipboard>
        <svg-icon name="clipboard" class="h-6 w-6 lg:hidden" />
      </template>
    </AppSideBar>
    <div class="max-w-4xl mx-auto p-6">
      <section id="mentions" class="mb-8">
        <h1 class="text-xl sm:text-2xl font-bold text-gray-800 mb-4 sm:mb-6">
          Mentions Légales
        </h1>
        <div class="space-y-4 text-sm sm:text-base">
          <div>
            <h2 class="font-semibold text-gray-700">Éditeur du Site</h2>
            <p><strong>Raison sociale :</strong> Time Manager SARL</p>
            <p>
              <strong>Adresse du siège social :</strong> 123 Boulevard de
              l'Horloge, 75000 Paris, France
            </p>
            <p><strong>Numéro de téléphone :</strong> +33 1 23 45 67 89</p>
            <p><strong>Adresse e-mail :</strong> contact@timemanager.fr</p>
            <p><strong>Numéro SIRET :</strong> 123 456 789 00123</p>
            <p>
              <strong>Directeur de la publication :</strong> [Nom du Directeur]
            </p>
          </div>
          <h2 class="text-xl font-semibold text-gray-700 mb-4">
            Hébergement du Site
          </h2>
          <p><strong>Nom de l'hébergeur :</strong> Hosting FR</p>
          <p>
            <strong>Adresse :</strong> 789 Rue du Serveur, 75000 Paris, France
          </p>
          <p><strong>Numéro de téléphone :</strong> +33 9 87 65 43 21</p>

          <h2 class="text-xl font-semibold text-gray-700 mb-4">
            Protection des Données Personnelles
          </h2>
          <p>
            Conformément à la loi "Informatique et Libertés" et au RGPD, les
            utilisateurs disposent d'un droit d'accès, de rectification, de
            suppression et d'opposition aux données les concernant. Pour
            l'exercer, adressez votre demande à : dpo@timemanager.fr.
          </p>

          <h2 class="text-xl font-semibold text-gray-700 mb-4">
            Propriété Intellectuelle
          </h2>
          <p>
            L'ensemble de ce site relève de la législation française et
            internationale sur le droit d'auteur et la propriété intellectuelle.
            Tous les droits de reproduction sont réservés.
          </p>
        </div>
      </section>

      <div class="container mx-auto py-6">
        <section id="terms">
          <h1 class="text-xl sm:text-2xl font-bold text-gray-800 mb-4 sm:mb-6">
            Conditions Générales d'Utilisation
          </h1>
          <div class="space-y-4 text-sm sm:text-base">
            <h2>Objet</h2>
            <p>
              Les présentes conditions régissent l'utilisation du site Time
              Manager. L'accès au site implique l'acceptation sans réserve des
              termes et conditions.
            </p>

            <h2>Données Personnelles</h2>
            <p>
              Time Manager s'engage à protéger les données personnelles et la
              vie privée de ses utilisateurs conformément au RGPD. Les
              informations collectées sont destinées uniquement à l'usage de
              Time Manager et ne seront pas divulguées sans consentement
              explicite.
            </p>

            <h2>Propriété Intellectuelle</h2>
            <p>
              Tout contenu publié et mis à disposition sur ce site est la
              propriété de Time Manager et de ses créateurs. Cela comprend, mais
              n'est pas limité à, des images, des textes, des logos, des
              documents téléchargeables et tout ce qui contribue à la
              composition du site.
            </p>

            <h2>Limitation de Responsabilité</h2>
            <p>
              Time Manager ne saurait être tenu pour responsable de tout
              dysfonctionnement technique du site, y compris toute interruption
              ou erreur de service.
            </p>

            <h2>Modifications</h2>
            <p>
              Time Manager se réserve le droit de modifier à tout moment les
              présentes conditions générales d'utilisation.
            </p>

            <p>
              Pour toute question relative à ces termes, veuillez nous contacter
              à l'adresse suivante : contact@timemanager.fr.
            </p>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>
