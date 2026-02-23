from django.db import models
from django.contrib.auth.models import User

# Create your models here.


# class Quiz(models.Model):
#     user = models.ForeignKey(User, on_delete=models.CASCADE)
#     title = models.CharField(max_length=255)


# class Question(models.Model):
#     quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE)
#     text = models.CharField(max_length=255)


# class Choice(models.Model):
#     question = models.ForeignKey(Question, on_delete=models.CASCADE)
#     text = models.CharField(max_length=255)
#     is_correct = models.BooleanField(default=False)

class QuizAttempt(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='quiz_attempts')
    topic = models.CharField(max_length=200)  
    difficulty = models.CharField(max_length=50)  
    total_questions = models.IntegerField()
    correct_answers = models.IntegerField()
    score_percentage = models.FloatField()
    
    # Store the complete quiz data as JSON
    quiz_data = models.JSONField()
    
    completed_at = models.DateTimeField(auto_now_add=True)
    time_taken = models.DurationField(null=True, blank=True)
    
    class Meta:
        ordering = ['-completed_at']
    
    def calculate_score(self):
        """Calculate score from the quiz_data"""
        if not self.quiz_data:
            return 0
            
        correct = 0
        total = len(self.quiz_data)
        
        for question in self.quiz_data:
            if question.get('answer_index') == question.get('chosen_answer'):
                correct += 1
                
        self.correct_answers = correct
        self.total_questions = total
        self.score_percentage = (correct / total * 100) if total > 0 else 0
        return self.score_percentage
    
    def save(self, *args, **kwargs):
        # Auto-calculate score before saving
        self.calculate_score()
        super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.user.username} - {self.topic} ({self.correct_answers}/{self.total_questions})"
    
    @property 
    def passed(self):
        return self.score_percentage >= 70  # Or whatever passing grade you want