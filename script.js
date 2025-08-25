document.addEventListener('DOMContentLoaded', function() {
    const tags = document.querySelectorAll('.tag');
    const publications = document.querySelectorAll('.publication-item');
    const resetFilterButton = document.querySelector('.reset-filter');
    let activeTag = null;
    
    // Add click event to each tag
    tags.forEach(tag => {
        tag.addEventListener('click', function() {
            const selectedTag = this.getAttribute('data-tag');
            
            // If this tag is already active, deactivate it
            if (this.classList.contains('active')) {
                this.classList.remove('active');
                resetFilterButton.style.display = 'none';
                activeTag = null;
                
                // Show all publications
                publications.forEach(publication => {
                    publication.classList.remove('hidden');
                });
            } else {
                // Reset all tags to inactive
                tags.forEach(t => t.classList.remove('active'));
                
                // Set clicked tag as active
                this.classList.add('active');
                activeTag = selectedTag;
                
                // Show reset filter button
                resetFilterButton.style.display = 'inline-block';
                
                // Filter publications
                publications.forEach(publication => {
                    const pubTags = publication.getAttribute('data-tags').split(',');
                    
                    if (pubTags.includes(selectedTag)) {
                        publication.classList.remove('hidden');
                    } else {
                        publication.classList.add('hidden');
                    }
                });
            }
        });
    });
    
    // Reset filter
    resetFilterButton.addEventListener('click', function() {
        publications.forEach(publication => {
            publication.classList.remove('hidden');
        });
        
        tags.forEach(tag => {
            tag.classList.remove('active');
        });
        
        activeTag = null;
        this.style.display = 'none';
    });
});