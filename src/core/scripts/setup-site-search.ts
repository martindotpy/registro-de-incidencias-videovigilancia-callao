import { TransitionBeforeSwapEvent } from "astro:transitions/client"

// Data
const PERSIST_ATTR = "data-astro-transition-persist"
const PERSIST_ID = "site-search"

// Persist
function persistOnNewDocument(event: Event) {
  if (!(event instanceof TransitionBeforeSwapEvent)) {
    return
  }

  const $newDoc = event.newDocument

  if (!$newDoc) {
    return
  }

  const $newSearch = $newDoc.querySelector<HTMLElement>("site-search")

  if ($newSearch) {
    $newSearch.setAttribute(PERSIST_ATTR, PERSIST_ID)
  }
}

function persistOnCurrentDocument() {
  const $siteSearch = document.querySelector<HTMLElement>("site-search")

  if ($siteSearch) {
    $siteSearch.setAttribute(PERSIST_ATTR, PERSIST_ID)
  }
}

// Initializer
persistOnCurrentDocument()
document.addEventListener("astro:before-swap", persistOnNewDocument)
document.addEventListener("astro:after-swap", persistOnCurrentDocument)
